# frozen_string_literal: true

require 'pagy/extras/limit'
require 'pagy/extras/array'
require 'pagy/extras/jsonapi'

Pagy::DEFAULT[:limit] = 5

Pagy::DEFAULT.freeze
