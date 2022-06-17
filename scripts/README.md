# Rebuilding Index

The Helm `index.yaml` is hosted on the `gh-pages` branch of this repo. If this
index becomes out-of-sync with the releases, you can rebuild it by using a
GitHub Actions Workflow.

## Prerequisites

- To use the `rebuild.sh` script with our workflow, the `rebuild.sh`
  script must be checked in to the `gh-pages` branch. If you make any changes
  to the script in this directory, make sure you also commit the same changes
  to the `gh-pages` branch.
- You must have permission to run GitHub Actions Workflows for this repo.

## Running the Action

- Navigate to the GitHub Actions UI.
- Use the `Run Workflow` button to run the workflow.
- Review the Pull Request created by the workflow.
- When approved, merge the Pull Request into the `gh-pages` branch.
