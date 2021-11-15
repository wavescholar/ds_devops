

#  FCMI:   Feature   Correlation   based   Missing   Data  Imputation
# @misc{mishra2021fcmi,
#       title={FCMI: Feature Correlation based Missing Data Imputation},
#       author={Prateek Mishra and Kumar Divya Mani and Prashant Johri and Dikhsa Arya},
#       year={2021},
#       eprint={2107.00100},
#       archivePrefix={arXiv},
#       primaryClass={cs.LG}
# }
#  Algorithm   1:   Feature   Correlation   based   Missing   data   Imputation  
#  Input:
#     x:   columns   with   missing   values  
#     m:   dataset   with   no   missing   values  
#     n:   dataset   containing   only   missing   values  
#
# Output:
# m:   updated   dataset   with   missing   values   imputed.  
#
# 1. for    each   missing   column   ( i )   in    x    do   :  
# 2. for    each   column   ( j )   in   the    dataset    do   :                       Calculate    correlation   coefficient    between   (    m[i]   and   m[j]    )   and   store   it   in    P                  end  
# 3. Set    ‘ K ’   =    top   3   columns   names   whose   correlation   is   maximum   w.r.t    m[i]  
# 4. Build    a   linear   regression   model     and   train   it   on   predictor   variables    k1,   k2,   k3                  and   target   as    m[i].    [The   parameters   of   the   linear   regression   model   is   optimized using   loss   function   described   in   Algorithm   2   ]  
# 5. Predict    the   values   of    n[i]    using   the   model   trained   in   4 .  
# 6. end

#---------------------------------------------------------------
#ut there is a correlation between Sex, PClass, and Age. Men are older than women and, passengers in the upper class are as well older than passengers in the lower class. We can use that to come up with a better replacement value than just the general average. We will use the mean of the category given by the sex and Pclass. Notice we used two categorical features (Pclass and Sex) to group the points to fill in missing values for a numerical feature (Age).
# Custom Transformer that fills missing ages
#https://towardsdatascience.com/pipelines-custom-transformers-in-scikit-learn-ef792bbb3260
class CustomImputer(BaseEstimator, TransformerMixin):
    def __init__(self):
        super().__init__()
        self.age_means_ = {}

    def fit(self, X, y=None):
        self.age_means_ = X.groupby(['Pclass', 'Sex']).Age.mean()

        return self

    def transform(self, X, y=None):
        # fill Age
        for key, value in self.age_means_.items():
            X.loc[((np.isnan(X["Age"])) & (X.Pclass == key[0]) & (X.Sex == key[1])), 'Age'] = value
            return X






#--------------------------https://www.kaggle.com/residentmario/simple-techniques-for-missing-data-imputation
import pandas as pd
pd.set_option('max_columns', None)
df = pd.read_csv("../input/recipeData.csv", encoding='latin-1').set_index("BeerID")
import missingno as msno
import matplotlib.pyplot as plt
msno.bar(df, figsize=(12, 6), fontsize=12, color='steelblue')

# Format the data for applying ML to it.
popular_beer_styles = (pd.get_dummies(df['Style']).sum(axis='rows') > (len(df) / 100)).where(lambda v: v).dropna().index.values

dfc = (df
       .drop(['PrimingMethod', 'PrimingAmount', 'UserId', 'PitchRate', 'PrimaryTemp', 'StyleID', 'Name', 'URL'], axis='columns')
       .dropna(subset=['BoilGravity'])
       .pipe(lambda df: df.join(pd.get_dummies(df['BrewMethod'], prefix='BrewMethod')))
       .pipe(lambda df: df.join(pd.get_dummies(df['SugarScale'], prefix='SugarScale')))
       .pipe(lambda df: df.assign(Style=df['Style'].map(lambda s: s if s in popular_beer_styles else 'Other')))
       .pipe(lambda df: df.join(pd.get_dummies(df['Style'], prefix='Style')))
       .drop(['BrewMethod', 'SugarScale', 'Style'], axis='columns')
      )

c = [c for c in dfc.columns if c != 'MashThickness']
X = dfc[dfc['MashThickness'].notnull()].loc[:, c].values
y = dfc[dfc['MashThickness'].notnull()]['MashThickness'].values
yy = dfc[dfc['MashThickness'].isnull()]['MashThickness'].values

# Apply a regression approach to imputing the mash thickness.
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import KFold
from sklearn.metrics import r2_score

import numpy as np
np.random.seed(42)
kf = KFold(n_splits=4)
scores = []
for train_index, test_index in kf.split(X):
    X_train, X_test = X[train_index], X[test_index]
    y_train, y_test = y[train_index], y[test_index]

    clf = LinearRegression()
    clf.fit(X_train, y_train)
    y_test_pred = clf.predict(X_test)

    scores.append(r2_score(y_test, y_test_pred))

print(scores)

from fancyimpute import MICE

trans = MICE()
trans.complete

from sklearn.datasets import make_classification
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Create a sample point cloud.
X, y = make_classification(n_samples=5000, n_features=2, n_informative=2,
                           n_redundant=0, n_repeated=0, n_classes=3,
                           n_clusters_per_class=1,
                           weights=[0.05, 0.10, 0.85],
                           class_sep=2, random_state=0)

# Select indices to drop labels from.
X_l = X.shape[0]
np.random.seed(42)
unl_idx = np.random.randint(0, len(X), size=X_l - 500)

# Back the labels up and drop them.
y = y.astype('float64')
X_train, y_train = X[unl_idx].copy(), y[unl_idx].copy()
X[unl_idx] = np.nan
y[unl_idx] = np.nan

# The fancyimpute package takes a single combined matrix as input. It differs in this from the X feature matrix, y response vector style of sklearn.
f = np.hstack((X, y[:, None]))

# Impute the missing values.
from fancyimpute import MICE
trans = MICE(verbose=False)
f_complete = trans.complete(f)

(f_complete == np.nan).any()
