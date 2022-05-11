# Run this app with `python app.py` and
# visit http://127.0.0.1:8050/ in your web browser.

from dash import Dash, dcc, html, Input, Output
import plotly.express as px
import plotly.graph_objects as go
import pandas as pd

app = Dash(__name__)
server = app.server
df = pd.read_csv('df_small.csv').dropna()

app.layout = html.Div([
    html.H1('Trees in NYC'),

    html.Div(['Borough',
        dcc.Dropdown(id = 'Borough',
        options = [{'label': i, 'value': i} for i in df['borough'].unique()],
        value = 'Manhattan',
        clearable = False)
    ]),

    html.Div(['Species',
        dcc.Dropdown(id = 'Species',
        options = [{'label': i, 'value': i} for i in df['spc_common'].unique()],
        value = df['spc_common'].unique(),
        clearable = False)
    ]),

    html.Br(),
    dcc.Graph(id = 'tree-map'),
    html.Br(),
    dcc.Graph(id = 'health-bar'),])

@app.callback(
    Output('tree-map', 'figure'),
    Input('Borough', 'value'),
    Input('Species', 'value'))

def update_map(borough, species):
    df_sub = df[(df['borough'] == borough) & (df['spc_common'] == species)]
    fig = px.scatter(df_sub, x = 'longitude', y = 'latitude', color = 'health',
                     color_discrete_sequence = ['green', 'yellow', 'red'])
    return fig

@app.callback(
    Output('health-bar', 'figure'),
    Input('Borough', 'value'),
    Input('Species', 'value'))

def update_bar(borough, species):
    df_sub = df[(df['borough'] == borough) & (df['spc_common'] == species)]

    fig = px.histogram(df_sub, x = 'steward', color = 'health',
                        color_discrete_sequence = ['green', 'yellow', 'red'])
    fig.update_xaxes(categoryorder = 'array',
                     categoryarray = ['None'])
    return fig

if __name__ == '__main__':
    app.run_server(debug=True)