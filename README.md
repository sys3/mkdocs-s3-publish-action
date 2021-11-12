# mkdocs-s3-publish-action

![license](https://img.shields.io/github/license/sys3/mkdocs-s3-publish-action)

Github Action to build and publish mkdocs rendered pages on Simple Storage Service (S3)
bucket without using Docker.
At the core this action is using the [Mkdocs Material](https://squidfunk.github.io/mkdocs-material/) project
to build your documentation.

## Why?

There are already a couple of great Github actions out there building your mkdocs project
and publishing it as Github pages such as

* <https://github.com/marketplace/actions/deploy-mkdocs>

This project aims to provide a Github action without using a Docker container in the build
and publishing step. It comes handy for people running in a Github Enterprise environment using
`self-hosted` runners which don't have Docker-in-Docker support enabled and publish to S3 bucket.

## Usage

Here is an example on how to use this action to publish your project:

```yaml
name: Build mkdocs pages and publish to S3 bucket

on:
  push:
    branches: [ main ]

jobs:
  build:
    name: Deploy docs
    runs-on: ubuntu-latest
    steps:
      - name: Checkout main
        uses: actions/checkout@v2

      - uses: actions/setup-python@v2
        with:
          python-version: 'pypy-3.6'

      - name: Deploy docs
        uses: sys3/mkdocs-s3-publish-action@main
        env:
          S3_LOCATION: ${{ secrets.S3_LOCATION }}
          S3_ACCESS_KEY: ${{ secrets.S3_ACCESS_KEY }}
          S3_SECRET_KEY: ${{ secrets.S3_SECRET_KEY }}
          S3_BUCKET: ${{ secrets.S3_BUCKET }}
```

## Configuration

This action can be configured by setting the following `env` varibles

| **ENV VAR**       | **Default Value**  | **Notes**                                                              |
| ----------------- | ------------------ | ---------------------------------------------------------------------- |
| **S3_LOCATION**   | `none`             | Specify the S3 Location (mandatory).                                   |
| **S3_ACCESS_KEY** | `none`             | Specify the S3 ACCESS_KEY (mandatory).                                 |
| **S3_SECRET_KEY** | `none`             | Specify the S3 SECRET_KEY  (mandatory).                                |
| **S3_BUCKET**     | `none`             | Specify a S3 bucket (mandatory) where to publish the pages.            |
| **BUCKET_DIR**    | `none`             | Specify a directory inside the S3 bucket (optinal)                     |
| **DOC_SITE**      | `sites`            | Specify a custom directory to save rendered mkdoc pages.               |
| **REQUIREMENTS**  | `requirements.txt` | Specify a custom `requirements.txt` file to use custom Python modules. |
| **FORCE**         | `"true"`           | Force defines if the `mkdocs` build artefacts should be build.         |

## Using custom modules

By default this action is looking for the presents of a `requirements.txt` in your project to install your custom modules.

Example: Lets say you want to install the following modules as they represent Mkdocs plugins used by your project:

```shell
mkdocs-same-dir==v0.1.0
mdx_truly_sane_lists==1.2
```

Create a corresponding file containing a versioned list of those modules (`pip freeze`). You can override the default filename `requirements.txt` by
setting the `REQUIREMENTS` environment variable.

```yaml
- name: Build pages and publish to S3
  uses: sys3/mkdocs-s3-publish-action@main
  env:
    S3_LOCATION: ${{ secrets.S3_LOCATION }}
    S3_ACCESS_KEY: ${{ secrets.S3_ACCESS_KEY }}
    S3_SECRET_KEY: ${{ secrets.S3_SECRET_KEY }}
    S3_BUCKET: ${{ secrets.S3_BUCKET }}
    REQUIREMENTS: myawesome-requirements.txt
```
