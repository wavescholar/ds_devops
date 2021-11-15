
#https://towardsdatascience.com/transformers-can-you-rate-the-complexity-of-reading-passages-17c76da3403

import numpy as np
import pandas as pd
import transformers
from matplotlib import pyplot as plt
from sklearn.model_selection import StratifiedKFold
import torch
import torch.nn as nn

# Dubious! Why are we mixing torch and tf ? 
#from tensorflow.python.framework.random_seed import set_random_seed

from transformers import RobertaModel, RobertaTokenizer

class MyDataset(torch.utils.data.Dataset):

    def __init__(self, texts, targets, tokenizer, seq_len=250):
        self.texts = texts
        self.targets = targets
        self.tokenizer = tokenizer
        self.seq_len = seq_len

    def __len__(self):
        """Returns the length of dataset."""
        return len(self.texts)

    def __getitem__(self, idx):
        text = str(self.texts[idx])
        tokenized = self.tokenizer(
            text,
            max_length=self.seq_len,
            padding="max_length",  # Pad to the specified max_length.
            truncation=True,  # Truncate to the specified max_length.
            add_special_tokens=True,  # Whether to insert [CLS], [SEP], <s>, etc.
            return_attention_mask=True
        )
        print("42")
        return {"ids": torch.tensor(tokenized["input_ids"], dtype=torch.long),
                "masks": torch.tensor(tokenized["attention_mask"], dtype=torch.long),
                "target": torch.tensor(self.targets[idx], dtype=torch.float)
                }


class MyModel(nn.Module):

    def __init__(self):
        super().__init__()
        self.roberta_model = RobertaModel.from_pretrained('roberta-base')
        self.regressor = nn.Linear(768, 1)

    def forward(self, input_ids, attention_mask):
        raw_output = self.roberta_model(input_ids, attention_mask, return_dict=True)
        pooler = raw_output["pooler_output"]  # Shape is [batch_size, 768]
        output = self.regressor(pooler)  # Shape is [batch_size, 1]
        return output

#Use roberta
class MyModel_AttnHead(nn.Module):

    def __init__(self):
        super().__init__()
        self.roberta_model = RobertaModel.from_pretrained('roberta-base')
        self.attn_head = AttentionHead(768, 512)
        self.regressor = nn.Linear(768, 1)

    def forward(self, input_ids, attention_mask):
        raw_output = self.roberta_model(input_ids, attention_mask, return_dict=True)
        last_hidden_state = raw_output["last_hidden_state"]  # Shape is [batch_size, seq_len, 768]
        attn = self.attn_head(last_hidden_state)  # Shape is [batch_size, 768]
        output = self.regressor(attn)  # Shape is [batch_size, 1]
        return output


class AttentionHead(nn.Module):

    def __init__(self, input_dim=768, hidden_dim=512):
        super().__init__()
        self.linear1 = nn.Linear(input_dim, hidden_dim)
        self.linear2 = nn.Linear(hidden_dim, 1)

    def forward(self, last_hidden_state):
        """
        Note:
        "last_hidden_state" shape is [batch_size, seq_len, 768].
        The "weights" produced from softmax will add up to 1 across all tokens in each record.
        """
        linear1_output = self.linear1(last_hidden_state)  # Shape is [batch_size, seq_len, 512]
        activation = torch.tanh(linear1_output)  # Shape is [batch_size, seq_len, 512]
        score = self.linear2(activation)  # Shape is [batch_size, seq_len, 1]
        weights = torch.softmax(score, dim=1)  # Shape is [batch_size, seq_len, 1]
        result = torch.sum(weights * last_hidden_state, dim=1)  # Shape is [batch_size, 768]
        return result


class MyModel_ConcatLast4Layers(nn.Module):

    def __init__(self):
        super().__init__()
        self.roberta_model = RobertaModel.from_pretrained('roberta-base')
        self.regressor = nn.Linear(768 * 4, 1)

    def forward(self, input_ids, attention_mask):
        raw_output = self.roberta_model(input_ids, attention_mask,
                                        return_dict=True, output_hidden_states=True)
        hidden_states = raw_output["hidden_states"]
        hidden_states = torch.stack(hidden_states)  # Shape is [13, batch_size, seq_len, 768]
        concat = torch.cat([hidden_states[i] for i in [-1, -2, -3, -4]], dim=-1)
        # Shape is [batch_size, seq_len, 768*4]
        first_token = concat[:, 0, :]  # Take only 1st token, result in shape [batch_size, 768*4]
        output = self.regressor(first_token)  # Shape is [batch_size, 1]
        return output

def loss_fn(predictions, targets):
    return torch.sqrt(nn.MSELoss()(predictions, targets))


def train_fn(data_loader, model, optimizer, device, scheduler):
    model.train()  # Put the model in training mode.

    lr_list = []
    train_losses = []

    for batch in data_loader:  # Loop over all batches.

        ids = batch["ids"].to(device, dtype=torch.long)
        masks = batch["masks"].to(device, dtype=torch.long)
        targets = batch["target"].to(device, dtype=torch.float)

        optimizer.zero_grad()  # To zero out the gradients.

        outputs = model(ids, masks).squeeze(-1)  # Predictions from 1 batch of data.

        loss = loss_fn(outputs, targets)  # Get the training loss.
        train_losses.append(loss.item())

        loss.backward()  # To backpropagate the error (gradients are computed).
        optimizer.step()  # To update parameters based on current gradients.
        lr_list.append(optimizer.param_groups[0]["lr"])
        scheduler.step()  # To update learning rate.

    return train_losses, lr_list


def validate_fn(data_loader, model, device):
    model.eval()  # Put model in evaluation mode.

    val_losses = []

    with torch.no_grad():  # Disable gradient calculation.

        for batch in data_loader:  # Loop over all batches.

            ids = batch["ids"].to(device, dtype=torch.long)
            masks = batch["masks"].to(device, dtype=torch.long)
            targets = batch["target"].to(device, dtype=torch.float)

            outputs = model(ids, masks).squeeze(-1)  # Predictions from 1 batch of data.

            loss = loss_fn(outputs, targets)  # Get the validation loss.
            val_losses.append(loss.item())

    return val_losses


def plot_train_val_losses(ax, train_df, val_df, y_cols, color, title, x_column=None, x_cumsum=False,
    plot_train=True, plot_val=True):

    assert plot_train or plot_val

    df = train_df.merge(val_df, on='epoch', suffixes=['_train','_val'])

    if isinstance(y_cols, tuple):
        assert(len(y_cols) == 2)
    else:
        y_cols = (y_cols,)

    val_col = y_cols[0] + '_val'
    train_col = y_cols[0] + '_train'
    if x_column is None:
        x = np.arange(df.shape[0])
        xlabel = 'batch'
    else:
        x = df[x_column].values
        if x_cumsum:
            x = np.cumsum(x)
        xlabel = x_column
    if plot_val: ax.plot(x, df[val_col], color=color, label=val_col)
    if plot_train: ax.plot(x, df[train_col], linestyle='--', color=color, label=train_col, alpha=0.5)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(y_cols[0])
    ax.grid(linestyle='--')
    ax.set_title(title)

    if len(y_cols) > 1:
        ax2 = ax.twinx()
        val_col = y_cols[1] + '_val'
        train_col = y_cols[1] + '_train'
        color = 'C' + str(int(color[1]) + 2)
        if plot_val: ax2.plot(x, df[val_col], color=color, label=val_col)
        if plot_train: ax2.plot(x, df[train_col], linestyle='--', color=color, label=train_col, alpha=0.5)
        ax2.set_xlabel(xlabel)
        ax2.set_ylabel(y_cols[1])
        ax2.set_ylim((0, 1))
        ax2.set_title(title)

# plot the learning rate schedule
def plot_lr_schedule(lr_schedule, name):
    plt.figure(figsize=(15,8))
    plt.plot(lr_schedule)
    schedule_info = f'start: {lr_schedule[0]}, max: {max(lr_schedule)}, final: {lr_schedule[-1]}'
    plt.title(f'Step Learning Rate Schedule {name}, {schedule_info}', size=16)
    plt.grid()
    plt.show()


def run_training(df, model_head="pooler"):
    """
    model_head: Accepted option is "pooler", "attnhead", or "concatlayer"
    """
    EPOCHS = 20
    FOLDS = [0, 1, 2, 3, 4]  # Set the list of folds you want to train
    EARLY_STOP_THRESHOLD = 3
    TRAIN_BS = 16  # Training batch size
    VAL_BS = 64  # Validation batch size
    cv = []  # A list to hold the cross validation scores

    # =========================================================================
    # Prepare data and model for training
    # =========================================================================

    for fold in FOLDS:

        from tensorflow.python.framework.random_seed import set_random_seed
        set_random_seed(3377)

        # Initialize the tokenizer
        tokenizer = RobertaTokenizer.from_pretrained("roberta-base")

        # Fetch training data
        df_train = df[df["skfold"] != fold].reset_index(drop=True)

        # Fetch validation data
        df_val = df[df["skfold"] == fold].reset_index(drop=True)

        # Initialize training dataset
        train_dataset = MyDataset(texts=df_train["excerpt"].values,
                                  targets=df_train["target"].values,
                                  tokenizer=tokenizer)

        # Initialize validation dataset
        val_dataset = MyDataset(texts=df_val["excerpt"].values,
                                targets=df_val["target"].values,
                                tokenizer=tokenizer)

        # Create training dataloader
        from torch.utils.data import DataLoader
        train_data_loader = DataLoader(train_dataset, batch_size=TRAIN_BS,
                                       shuffle=True, num_workers=2)

        # Create validation dataloader
        val_data_loader = DataLoader(val_dataset, batch_size=VAL_BS,
                                     shuffle=False, num_workers=2)

        # Initialize the cuda device (or use CPU if you don't have GPU)
        device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

        # Load model and send it to the device.
        if model_head == "pooler":
            model = MyModel().to(device)
        elif model_head == "attnhead":
            model = MyModel_AttnHead().to(device)
        elif model_head == "concatlayer":
            model = MyModel_ConcatLast4Layers().to(device)
        else:
            raise ValueError(f"Unknown model_head: {model_head}")

            # Get the AdamW optimizer
        optimizer = transformers.AdamW(model.parameters(), lr=1e-6)

        # Calculate the number of training steps (this is used by scheduler).
        # training steps = [number of batches] x [number of epochs].
        train_steps = int(len(df_train) / TRAIN_BS * EPOCHS)

        # Get the learning rate scheduler
        scheduler = transformers.get_scheduler(
            "linear",  # Create a schedule with a learning rate that decreases linearly
            # from the initial learning rate set in the optimizer to 0.
            optimizer=optimizer,
            num_warmup_steps=0,
            num_training_steps=train_steps)

        # =========================================================================
        # Training Loop - Start training the epochs
        # =========================================================================

        print(f"===== FOLD: {fold} =====")
        best_rmse = 999
        early_stopping_counter = 0
        all_train_losses = []
        all_val_losses = []
        all_lr = []

        for epoch in range(EPOCHS):

            # Call the train function and get the training loss
            train_losses, lr_list = train_fn(train_data_loader, model, optimizer, device, scheduler)
            train_loss = np.mean(train_losses)
            all_train_losses.append(train_loss)
            all_lr.extend(lr_list)

            # Perform validation and get the validation loss
            val_losses = validate_fn(val_data_loader, model, device)
            val_loss = np.mean(val_losses)
            all_val_losses.append(val_loss)

            rmse = val_loss

            # If there's improvement on the validation loss, save the model checkpoint.
            # Else do early stopping if threshold is reached.
            if rmse < best_rmse:
                torch.save(model.state_dict(), f"roberta_base_fold_{fold}.pt")
                print(f"FOLD: {fold}, Epoch: {epoch}, RMSE = {round(rmse, 4)}, checkpoint saved.")
                best_rmse = rmse
                early_stopping_counter = 0
            else:
                print(f"FOLD: {fold}, Epoch: {epoch}, RMSE = {round(rmse, 4)}")
                early_stopping_counter += 1
            if early_stopping_counter > EARLY_STOP_THRESHOLD:
                print(f"FOLD: {fold}, Epoch: {epoch}, RMSE = {round(rmse, 4)}")
                print(f"Early stopping triggered! Best RMSE: {round(best_rmse, 4)}\n")
                break

        # Plot the losses and learning rate schedule.
        plot_train_val_losses(all_train_losses, all_val_losses, fold)
        plot_lr_schedule(all_lr)

        # Keep the best_rmse as cross validation score for the fold.
        cv.append(best_rmse)

    # Print the cross validation scores and their average.
    cv_rounded = [round(elem, 4) for elem in cv]
    print(f"CV: {cv_rounded}")
    print(f"Average CV: {round(np.mean(cv), 4)}\n")




if __name__ == "__main__":

    df = pd.read_csv('~/kaggle_projects/train.csv')
    # Note: df is the dataframe containing the data.
    df = pd.read_csv('~/kaggle_projects/train.csv')

    df = df.sample(frac=1).reset_index(drop=True)
    bins = int(np.floor(1 + np.log2(len(df))))
    df.loc[:, "bins"] = pd.cut(df["target"], bins=bins, labels=False)
    skf = StratifiedKFold(n_splits=5)

    for fold, (train_idx, val_idx) in enumerate(skf.split(X=df, y=df["bins"].values)):
        df.loc[val_idx, "skfold"] = fold

    run_training(df)

    print(42)
