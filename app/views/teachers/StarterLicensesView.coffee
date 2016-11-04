RootView = require 'views/core/RootView'
State = require 'models/State'
Products = require 'collections/Products'
PurchaseStarterLicensesModal = require 'views/teachers/PurchaseStarterLicensesModal'
TeachersContactModal = require 'views/teachers/TeachersContactModal'

{ MAX_STARTER_LICENSES, STARTER_LICENCE_LENGTH_MONTHS } = require 'core/constants'

module.exports = class StarterLicensesView extends RootView
  id: 'starter-licenses-view'
  template: require 'templates/teachers/starter-licenses-view'

  i18nData:
    maxQuantityStarterLicenses: MAX_STARTER_LICENSES
    starterLicenseLengthMonths: STARTER_LICENCE_LENGTH_MONTHS
    starterLicenseCourseList: 'Computer Science 2, Web Development 1, and Game Development 1'
    
  events:
    'click .purchase-btn': 'onClickPurchaseButton'
    'click .contact-us-btn': 'onClickContactUsButton'

  initialize: (options) ->
    @state = new State({
      dollarsPerStudent: undefined
    })
    @products = new Products()
    @supermodel.trackRequest @products.fetch()
    @listenTo @products, 'sync', ->
      centsPerStudent = @products.getByName('starter_license')?.get('amount')
      @state.set {
        dollarsPerStudent: centsPerStudent/100
      }
    @listenTo @state, 'change', ->
      @render()

  onClickPurchaseButton: ->
    @openModalView(new PurchaseStarterLicensesModal())

  onClickContactUsButton: ->
    window.tracker?.trackEvent 'Classes Starter Licenses Upsell Contact Us', category: 'Teachers', ['Mixpanel']
    @openModalView(new TeachersContactModal())
