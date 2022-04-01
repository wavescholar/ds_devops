# Run this app with `python dash_demo.py` and
# visit http://127.0.0.1:8050/
from dash import Dash, html, dcc
import plotly.express as px
import pandas as pd

adobe_client_api_keyname='bcam_fitchdemo'
adobe_client_api_key='f27ea3d207e74d7ab282c571693b867b'

app = Dash(__name__)

df = pd.DataFrame({
    "Fruit": ["Apples", "Oranges", "Bananas", "Apples", "Oranges", "Bananas"],
    "Amount": [4, 1, 2, 2, 4, 5],
    "City": ["SF", "SF", "SF", "Montreal", "Montreal", "Montreal"]
})

fig = px.bar(df, x="Fruit", y="Amount", color="City", barmode="group")

app.layout = html.Div(children=[
    html.H1(children='Hello Dash'),

    html.Div(children='''
        Dash: A web application framework for your data.
    '''),

    dcc.Graph(
        id='example-graph',
        figure=fig
    )
])

if __name__ == '__main__':
    app.run_server(debug=True)
