#pip install scs
# OR
#python setup.py install --scs --gpu

#While DCP is a ruleset for constructing convex programs, DGP is a ruleset for log-log convex programs (LLCPs), which are problems that are convex after the variables, objective functions, and constraint functions are replaced with their logs, an operation that we refer to as a log-log transformation.
#Disciplined geometric programming (DGP), which lets you formulate and solve log-log convex programs (LLCPs) in CVXPY.

git clone --recursive https://github.com/bodono/scs-python.git
cd scs-python
python setup.py install
# OR
#python setup.py install --scs --gpu

pytest
