# Changelog Script

Changelog script helps projects to generate changelogs and update their markdown files during release process.

- [Getting started](#getting-started)
  - [Pre-requisites](#pre-requisites)
  - [Tools](#tools)
- [Generating Changelog Entry](#generating-changelog-entry)
- [Updating Changelog Files](#updating-changelog-files)
- [Retrieving Released Changelogs](#retrieving-released-changelogs)

## Getting started

This section will contain the necessary instructions to enable you to run the project.

### Pre-requisites

Before starting changelog script you should update your project structure with creating changelogs/ folder under your project root.

#### Tools

- Ruby must be installed in system where you run changelog scripts. Suggested version is 2.6.x.
- Run `gem install bundler` to install ruby dependency manager
- Run `bundle install` to install necessary ruby packages

## Generating Changelog Entry

When you start to work on new ticket, most probably you will want to create changelog entry for it. Rather than updating your CHANGELOG.Md file, you should run this script. Basically this script:
- Copies sample changelog entry from this repository to {YOUR_PROJECT_PATH}/changelogs/unreleased folder.
- It also checks your current git branch name. if there is any CX-XXXX pattern in the branch name, script renames json file same as your current branch name.

Example script usage:

```shell
$ ./bin/create_changelog_entry.rb --project-path '/Users/admin/Desktop/dev/repo/onfido-ios-sdk'
```
### Parameters

| Paremeter Name | Required          | Description                           |
|--------------------------------|---------------|----------------------------------|
| project-path                       | YES | Root path of your project                            |

**Note**: --project-path parameter is required

## Updating Changelog Files

During release process, you may want to update your changelog or migration files based on the changelog entries generated until that time. This script allows you to update your internal/public changelog and migration files to be updated.

Example script usage:

```shell
$ ./bin/update_changelog_files.rb --project-path '/Users/admin/Desktop/dev/repo/onfido-ios-sdk' \
--sdk-version '18.0.0' \
--platform 'ios' \
--internal-changelog-file-path 'CHANGELOG-INTERNAL.md' \
--public-changelog-file-path 'documentation/CHANGELOG.md' \
--migration-file-path 'documentation/MIGRATION.md'
```

### Parameters

| Paremeter Name | Required          | Description                           |
|--------------------------------|---------------|----------------------------------|
| project-path                       | YES | Root path of your project            
| sdk-version                 | YES| New SDK version you're about to release |
|platform           | YES | Can be either `ios`, `android` or `js`  |
| internal-changelog-file-path                | NO | Relative path of internal changelog file, don't pass this parameter if you don't use internal change log  in your project                            |
| public-changelog-file-path                           | YES | Relative path of public changelog file                              |
| migration-file-path                     | NO | Relative path of migration file, don't pass this parameter if you don't use migration document or you want to manage it on your own |

## Retrieving Released Changelogs

At any time, you may want to retrieve released changelogs. This script prints you to know what changes has been done for given version.

Example script usage:

```shell
$ ./bin/retrieve_released_changelogs.rb --project-path '/Users/admin/Desktop/dev/repo/onfido-ios-sdk' \
--sdk-version '18.0.0' \
--public-only
```

### Parameters

| Paremeter Name | Required          | Description                           |
|--------------------------------|---------------|----------------------------------|
| project-path                       | YES | Root path of your project            
| sdk-version                 | YES|  SDK version you want to get information |
| public-only                     | NO | Indicates that you want to get only `public` changelog entries. Don't pass it if you want to get all changes|


**Hint**: You can create bash or ruby script wrappers to prevent sending same parameters over and over again.
