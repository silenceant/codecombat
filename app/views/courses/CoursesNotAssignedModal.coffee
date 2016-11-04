ModalView = require 'views/core/ModalView'
template = require 'templates/courses/courses-not-assigned-modal'

module.exports = class CoursesNotAssignedModal extends ModalView
  id: 'courses-not-assigned-modal'
  template: template

  initialize: (options) ->
    @i18ndata = options
    # @promoteStarterLicenses =
