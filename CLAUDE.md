# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

bp3-activeadmin adapts `activeadmin` (4.x) for BP3 (persuavis/black_phoebe_3), a multi-site multi-tenant
Rails application. It keeps ActiveAdmin's default filters inside what each model allows ransack to search.

## Commands

The gems run on Ruby 3.4.6 (`.ruby-version`). Prefix commands with `~/.rvm/bin/rvm 3.4.6 do` when the
shell is not already on it; a missing `rspec` means the wrong Ruby, not a missing bundle.

- `bundle exec rake` - specs and RuboCop (the default task)
- `bundle exec rspec spec/path/to/file_spec.rb[:LINE]` - one file or example
- `bundle exec rubocop` / `bundle exec rubocop -a`
- `bin/setup`, `bin/console`, `rake install`

## Architecture

`lib/bp3/activeadmin/railtie.rb` runs in an `after_initialize` block:

- prepends `PrependResourceExtension` to `ActiveAdmin::Filters::ResourceExtension`, so `default_filters`
  keeps only the fields in `resource_class.ransackable_fields(auth_object)` (from `Bp3::Core::Ransackable`)
- `auth_object` is the configured request state class sent the configured method
- includes `Bp3::Core::Ransackable` in `ActiveAdmin::Comment`

**Configuration** (`lib/bp3/activeadmin.rb`): `Bp3::Activeadmin.global_request_state_class_name` and
`.global_request_state_method`. The application's `config/initializers/bp3-activeadmin.rb` sets them to
`'GlobalRequestState'` and `:current_login` (the README's example still shows `:highest_privilege`).

The entry file is `lib/bp3-active_admin.rb`, not `lib/bp3-activeadmin.rb`; Bundler's autorequire finds
`bp3/activeadmin` instead.

## Testing

The spec only checks the version; the Railtie needs a Rails application with ActiveAdmin to exercise. Try a
change against the application (black_phoebe_3) by putting this repo's `lib` ahead of the bundled gem.

## Code Style

- RuboCop (`.rubocop.yml`): target Ruby 3.2.2, NewCops, rubocop-rake and rubocop-rspec; AbcSize 26,
  MethodLength 15, BlockLength 66, ModuleLength 150; `Lint/ConstantDefinitionInBlock` and `Lint/Void`
  are off for `lib/bp3/**/railtie.rb`, where classes are reopened inside a block
- Every file starts with `# frozen_string_literal: true`
- American English; no trailing whitespace on any added or modified line

## Release

Bump `lib/bp3/activeadmin/version.rb` and add a `CHANGELOG.md` entry. `rake release` tags, pushes and
publishes to rubygems.org; leave releasing and committing to the user.
