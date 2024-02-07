pipx is a utility for installing and running Python applications in isolated environments.

```
pip install pipx
python -m pip install --user cookie-cutter
```

Or

```
sudo apt install pipx
pipx install cookiecutter
pipx  ensurepath
```

We made a fork of cookie-cutter : 

```
git clone https://github.com/wavescholar/ws-cookiecutter-pypackage.git

```

Make mods of the cookiecutter.json file
and generate 

```
cookiecutter ws-cookiecutter-pypackage/
```
