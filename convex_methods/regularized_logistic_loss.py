# model fitting problem with logistic loss and L1 regularization.
from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
import cvxpy as cp

# In this example, we use CVXPY to train a logistic regression classifier with ℓ1 regularization. We are given data (xi,yi), i=1,…,m. The xi∈Rn are feature vectors, while the yi∈{0,1} are associated boolean classes.
# Our goal is to construct a linear classifier ŷ =𝟙[βTx>0], which is 1 when βTx is positive and 0 otherwise. We model the posterior probabilities of the classes given the data linearly, with
# logPr(Y=1∣X=x)Pr(Y=0∣X=x)=βTx.
# This implies that
# Pr(Y=1∣X=x)=exp(βTx)1+exp(βTx),Pr(Y=0∣X=x)=11+exp(βTx).
# We fit β by maximizing the log-likelihood of the data, plus a regularization term λ‖β‖1 with λ>0:
# ℓ(β)=∑i=1myiβTxi−log(1+exp(βTxi))−λ‖β‖1.
# Because ℓ is a concave function of β, this is a convex optimization problem.

# Construct Z given X.
def pairs(Z):
    m, n = Z.shape
    k = n * (n + 1) // 2
    X = np.zeros((m, k))
    count = 0
    for i in range(n):
        for j in range(i, n):
            X[:, count] = Z[:, i] * Z[:, j]
            count += 1
    return X


# Generate data for logistic model fitting problem.
np.random.seed(1)
n = 10
k = n * (n + 1) // 2
m = 200
TEST = 100
sigma = 1.9
DENSITY = 1.0
theta_true = np.random.randn(n, 1)

idxs = np.random.choice(range(n), int((1 - DENSITY) * n), replace=False)
for idx in idxs:
    beta_true[idx] = 0


Z = np.random.binomial(1, 0.5, size=(m, n))
Y = np.sign(Z.dot(theta_true) + np.random.normal(0, sigma, size=(m, 1)))
X = pairs(Z)
X = np.hstack([X, np.ones((m, 1))])
Z_test = np.random.binomial(1, 0.5, size=(TEST, n))
Y_test = np.sign(Z_test.dot(theta_true) + np.random.normal(0, sigma, size=(TEST, 1)))
X_test = pairs(Z_test)
X_test = np.hstack([X_test, np.ones((TEST, 1))])

theta = cp.Variable((k + 1, 1))
lambd = cp.Parameter(nonneg=True)
loss = cp.sum(
    cp.log_sum_exp(cp.hstack([np.zeros((m, 1)), -cp.multiply(Y, X @ theta)]), axis=1)
)
reg = cp.norm(theta[:k], 1)
prob = cp.Problem(cp.Minimize(loss / m + lambd * reg))
# Compute a trade-off curve and record train and test error.
TRIALS = 100
train_error = np.zeros(TRIALS)
test_error = np.zeros(TRIALS)
lambda_vals = np.logspace(-4, 0, TRIALS)
for i in range(TRIALS):
    lambd.value = lambda_vals[i]
    prob.solve(solver=cp.SCS)
    train_error[i] = (
        np.sign(Z.dot(theta_true)) != np.sign(X.dot(theta.value))
    ).sum() / m
    test_error[i] = (
        np.sign(Z_test.dot(theta_true)) != np.sign(X_test.dot(theta.value))
    ).sum() / TEST
# Plot the train and test error over the trade-off curve.

plt.plot(lambda_vals, train_error, label="Train error")
plt.plot(lambda_vals, test_error, label="Test error")
plt.xscale("log")
plt.legend(loc="upper left")
plt.xlabel(r"$\lambda$", fontsize=16)
plt.show()

# Below we plot |θk|, k=1,…,55, for the λ that minimized the test error. Each |θk| is placed at position (i,j) where zizj=xk. Notice that many θk are 0, as we would expect with ℓ1 regularization.

# Solve model fitting problem with the lambda that minimizes test error.
idx = np.argmin(test_error)
lambd.value = lambda_vals[idx]
prob.solve(solver=cp.SCS)

# Plot the absolute value of the entries in theta corresponding to each feature.
P = np.zeros((n, n))
count = 0
for i in range(n):
    for j in range(i, n):
        P[i, j] = np.abs(theta.value[count])
        count += 1
row_labels = range(1, n + 1)
column_labels = range(1, n + 1)

fig, ax = plt.subplots()
heatmap = ax.pcolor(P, cmap=plt.cm.Blues)

# put the major ticks at the middle of each cell
ax.set_xticks(np.arange(P.shape[1]) + 0.5, minor=False)
ax.set_yticks(np.arange(P.shape[0]) + 0.5, minor=False)

# want a more natural, table-like display
ax.invert_yaxis()
ax.xaxis.tick_top()

ax.set_xticklabels(column_labels, minor=False)
ax.set_yticklabels(row_labels, minor=False)

plt.xlabel(r"$z_i$", fontsize=16)
ax.xaxis.set_label_position("top")
plt.ylabel(r"$z_j$", fontsize=16)
plt.show()
