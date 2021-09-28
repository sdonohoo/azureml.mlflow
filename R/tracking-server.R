# Setup MLFlow logging for AzureML

# Load R mlflow library
# Compute environment prerequisites:
#   * azureml-mlflow python package installed (this installs mlflow and linkage to azureml)
#   * mlflow R package installed
#   * Set environment variables to point to mlflow installed by azureml-mlflow.
#     Running R's mlflow::install() unnecessary:
#     MLFLOW_PYTHON_BIN=/usr/bin/python
#     MLFLOW_BIN=/usr/local/bin/mlflow

library(mlflow)
library(carrier)

mlflow_get_azureml_tracking_uri <- function()
{
  # AzureML tracking URI to use with MLFlow is set in MLFLOW_TRACKING_URI env in AmlCompute
  # and will be picked up by mlflow_tracking_uri() but needs to be modified for use with R mlflow:
  #
  # Original format from env: 'azureml://<tracking uri>?&is-remote=True'
  # Required format: 'https://<tracking uri>

  # Get current tracking URI
  env_tracking_uri <- mlflow::mlflow_get_tracking_uri()
  # Remove ?&is-remote=True
  azureml_tracking_uri <- sub("\\?.*", "", env_tracking_uri)
  # Change azureml:// to https://
  azureml_tracking_uri = sub("azureml://", "https://", azureml_tracking_uri)
  # Update tracking URI
  #mlflow_set_tracking_uri(azureml_tracking_uri)
  Sys.setenv('MLFLOW_TRACKING_URI'=azureml_tracking_uri)

  #print(tracking_uri)

  ## Note: the above tracking URI works if the job is submitted to AmlCompute
  ## TO-DO: Test local run with AzureML MLFlow logging by getting tracking URI via 'az ml workspace show'
  # Check if az and ml extension are installed and version
  # system('az version --query extensions.ml')
  # Get MLFLOW_TRACKING_URI via the workspace
  # MLFLOW_TRACKING_URI <- system('az ml workspace show --query mlflow_tracking_uri -o tsv',intern = TRUE)[2]
  # Use 'az account' to set MLFLOW_TRACKING_TOKEN?

  azureml_tracking_uri
}
