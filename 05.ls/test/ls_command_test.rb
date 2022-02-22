# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../lib/ls_command'

class LsCommandTest < Minitest::Test
  TARGET_PATHNAME = Pathname('test/fixtures/sample-app')

  def test_run_width_128
    expected = <<~TEXT.chomp
      Dockerfile                      app.json                        config                          postcss.config.js
      Gemfile                         babel.config.js                 config.ru                       public
      Gemfile.lock                    bin                             db                              test
      LICENSE                         cloudbuild-delete.yaml          doc                             vendor
      Procfile                        cloudbuild-reset.yaml           docker-compose.darwin.yml       yarn.lock
      README.md                       cloudbuild-staging.yaml         lib
      Rakefile                        cloudbuild-task.yaml            log
      app                             cloudbuild.yaml                 package.json
    TEXT
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 128)
  end

  def test_run_width_127
    expected = <<~TEXT.chomp
      Dockerfile                      app.json                        config                          postcss.config.js
      Gemfile                         babel.config.js                 config.ru                       public
      Gemfile.lock                    bin                             db                              test
      LICENSE                         cloudbuild-delete.yaml          doc                             vendor
      Procfile                        cloudbuild-reset.yaml           docker-compose.darwin.yml       yarn.lock
      README.md                       cloudbuild-staging.yaml         lib
      Rakefile                        cloudbuild-task.yaml            log
      app                             cloudbuild.yaml                 package.json
    TEXT
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 127)
  end

  def test_run_width_64
    expected = <<~TEXT.chomp
      Dockerfile                      cloudbuild.yaml
      Gemfile                         config
      Gemfile.lock                    config.ru
      LICENSE                         db
      Procfile                        doc
      README.md                       docker-compose.darwin.yml
      Rakefile                        lib
      app                             log
      app.json                        package.json
      babel.config.js                 postcss.config.js
      bin                             public
      cloudbuild-delete.yaml          test
      cloudbuild-reset.yaml           vendor
      cloudbuild-staging.yaml         yarn.lock
      cloudbuild-task.yaml
    TEXT
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 64)
  end

  def test_run_width_63
    expected = <<~TEXT.chomp
      Dockerfile                      cloudbuild.yaml
      Gemfile                         config
      Gemfile.lock                    config.ru
      LICENSE                         db
      Procfile                        doc
      README.md                       docker-compose.darwin.yml
      Rakefile                        lib
      app                             log
      app.json                        package.json
      babel.config.js                 postcss.config.js
      bin                             public
      cloudbuild-delete.yaml          test
      cloudbuild-reset.yaml           vendor
      cloudbuild-staging.yaml         yarn.lock
      cloudbuild-task.yaml
    TEXT
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 63)
  end

  def test_run_width_1
    expected = <<~TEXT.chomp
      Dockerfile
      Gemfile
      Gemfile.lock
      LICENSE
      Procfile
      README.md
      Rakefile
      app
      app.json
      babel.config.js
      bin
      cloudbuild-delete.yaml
      cloudbuild-reset.yaml
      cloudbuild-staging.yaml
      cloudbuild-task.yaml
      cloudbuild.yaml
      config
      config.ru
      db
      doc
      docker-compose.darwin.yml
      lib
      log
      package.json
      postcss.config.js
      public
      test
      vendor
      yarn.lock
    TEXT
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 1)
  end

  def test_run_ls_long_format
    expected = `ls -l #{TARGET_PATHNAME}`.chomp
    assert_equal expected, run_ls(TARGET_PATHNAME, long_format: true)
  end

  def test_run_ls_reverse
    expected = <<~TEXT.chomp
      yarn.lock                       docker-compose.darwin.yml       cloudbuild-reset.yaml           Procfile
      vendor                          doc                             cloudbuild-delete.yaml          LICENSE
      test                            db                              bin                             Gemfile.lock
      public                          config.ru                       babel.config.js                 Gemfile
      postcss.config.js               config                          app.json                        Dockerfile
      package.json                    cloudbuild.yaml                 app
      log                             cloudbuild-task.yaml            Rakefile
      lib                             cloudbuild-staging.yaml         README.md
    TEXT
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 128, reverse: true)
  end

  def test_run_ls_show_dots
    expected = <<~TEXT.chop
      .                               .nvmrc                          app                             doc
      ..                              .prettierrc                     app.json                        docker-compose.darwin.yml
      .browserslistrc                 .rubocop.yml                    babel.config.js                 lib
      .devcontainer                   .ruby-version                   bin                             log
      .dockerignore                   .traceroute.yml                 cloudbuild-delete.yaml          package.json
      .eslintrc                       Dockerfile                      cloudbuild-reset.yaml           postcss.config.js
      .gcloudignore                   Gemfile                         cloudbuild-staging.yaml         public
      .git                            Gemfile.lock                    cloudbuild-task.yaml            test
      .git-pr-release                 LICENSE                         cloudbuild.yaml                 vendor
      .github                         Procfile                        config                          yarn.lock
      .gitignore                      README.md                       config.ru
      .node-version                   Rakefile                        db
    TEXT
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 128, show_dots: true)
  end

  def test_run_ls_all_options
    expected = `ls -lar #{TARGET_PATHNAME}`.chomp
    assert_equal expected, run_ls(TARGET_PATHNAME, long_format: true, reverse: true, show_dots: true)
  end
end
