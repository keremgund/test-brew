# SDK Copy Management

This repo helps projects to integrate with SDK copy management tool (currently Lokalise).

- [Getting started](#getting-started)
  - [Tools](#tools)
- [Fetching Strings](#fetching-strings)
- [Checking Strings](#checking-strings)

## Getting started

This section will contain the necessary instructions to enable you to run the project.

#### Tools

- Ruby must be installed in system where you run scripts. Suggested version is 2.6.x.
- Run `gem install bundler` to install ruby dependency manager
- Run `bundle install` to install necessary ruby packages

## Fetching Strings

When copies are updated on lokalise, at some point SDK projects will have to adopt those changes. Rather than  moving copy changes manually from lokalise to the project, this script helps you to fetch changes in one go.

So this script:

- Finds string changes with the given tag.
- Retrieves those changes and applies changes to string files of the project.

Example script usage:

```shell
$ ./bin/fetch-strings.rb --tag 'CX-5433 NFC UI' \
--platform ios \
--project-path /Users/kerem.gunduz/Desktop/dev/repo/onfido-ios-sdk \
--lokalise-project-id YYY \
--lokalise-token XXX
```

### Parameters

| Paremeter Name | Required          | Description                           |
|--------------------------------|---------------|----------------------------------|
| tag                      | YES | Tag name you want to use on lokalise to fetch updates |
| platform                 | YES | Platform value, can be either ios or android |
| project-path             | YES | Root path of your project |
| lokalise-project-id      | YES | Lokalise project id value, can be retrieved from https://app.lokalise.com/              |
| lokalise-token           | YES | Lokalise token value, can be retrieved from https://app.lokalise.com/ |

## Checking Strings

This script helps you to understand whether strings on lokalise and project are consistent. It checks missing, extra strings along with mismatched translations.

Example script usage:

```shell
$  ./bin/check-strings.rb --lang en_US \
  --platform android \
  --branch new_auto_capture_alert \
  --project-path /Users/kerem.gunduz/Desktop/dev/repo/android-capture-sdk/onfido-capture-sdk-core/src/main/res \
  --lokalise-project-id XXX \
  --lokalise-token YYY
```

### Parameters

| Paremeter Name | Required          | Description                      |
|----------------|-------------------|----------------------------------|
| project-path      | YES | Root path of your project |           
| platform          | YES | Platform value, can be either ios or android |
| lang              | YES | Language code |
| branch            | YES | Lokalise branch name |
| lokalise-project-id  | YES | Lokalise project id value, can be retrieved from https://app.lokalise.com/ |
| lokalise-token   | YES | Lokalise token value, can be retrieved from https://app.lokalise.com/ |

**Hint**: You can run scripts with `-h` option to get more detailed usage explanation.
**Hint**: You can create bash or ruby script wrappers to prevent sending same parameters over and over again.
