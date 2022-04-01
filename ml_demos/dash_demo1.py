from dash import Dash, html

#external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

#app = Dash(__name__), external_stylesheets=external_stylesheets)
app = Dash(__name__)

app.index_string = '''
<!DOCTYPE html>
<html><head>
  {%metas%}
  <title>{%title%}</title>
  {%favicon%}
  {%css%}
  <title>Your title</title>
  <meta charset="utf-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
  <script src="https://documentcloud.adobe.com/view-sdk/main.js"></script>
</head>
<body>
  <div id="adobe-dc-view"></div>
  <script type="text/javascript">
   document.addEventListener("adobe_dc_view_sdk.ready", function()
   {
      var adobeDCView = new AdobeDC.View({clientId: "f27ea3d207e74d7ab282c571693b867b", divId: "adobe-dc-view"});
      adobeDCView.previewFile(
     {
         content:  {location: {url: "/home/wavescholar/work/ds_devops/ml_demos/doc.pdf"}},
         metaData: {fileName: "/home/wavescholar/work/ds_devops/ml_demos/doc.pdf"}
     });
   });
  </script>
  <footer>
    {%config%}
    {%scripts%}
    {%renderer%}
  </footer>
  {%app_entry%}
</body>
</html>
'''

app.layout = html.Div('Simple Dash App')

if __name__ == '__main__':
    app.run_server(debug=True)