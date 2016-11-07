RootView = require 'views/core/RootView'
State = require 'models/State'
Products = require 'collections/Products'
PurchaseStarterLicensesModal = require 'views/teachers/PurchaseStarterLicensesModal'
TeachersContactModal = require 'views/teachers/TeachersContactModal'
Courses = require 'collections/Courses'
utils = require 'core/utils'

{
  MAX_STARTER_LICENSES
  STARTER_LICENCE_LENGTH_MONTHS
  STARTER_LICENSE_COURSE_IDS
  FREE_COURSE_IDS
} = require 'core/constants'

module.exports = class StarterLicensesView extends RootView
  id: 'starter-licenses-view'
  template: require 'templates/teachers/starter-licenses-view'

  i18nData: ->
    maxQuantityStarterLicenses: MAX_STARTER_LICENSES
    starterLicenseLengthMonths: STARTER_LICENCE_LENGTH_MONTHS
    starterLicenseCourseList: @state.get('starterLicenseCourseList')
    
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
    @courses = new Courses()
    @supermodel.trackRequest @courses.fetch()
    @listenTo @courses, 'sync', ->
      COURSE_IDS = _.difference(STARTER_LICENSE_COURSE_IDS, FREE_COURSE_IDS)
      starterLicenseCourseList = _.difference(STARTER_LICENSE_COURSE_IDS, FREE_COURSE_IDS).map (_id) =>
        utils.i18n(@courses.findWhere({_id})?.attributes, 'name')
      starterLicenseCourseList.push($.t('general.and') + ' ' + starterLicenseCourseList.pop())
      starterLicenseCourseList = starterLicenseCourseList.join(', ')
      @state.set { starterLicenseCourseList }
    @listenTo @state, 'change', ->
      @render()

  onClickPurchaseButton: ->
    @openModalView(new PurchaseStarterLicensesModal())

  onClickContactUsButton: ->
    window.tracker?.trackEvent 'Classes Starter Licenses Upsell Contact Us', category: 'Teachers', ['Mixpanel']
    @openModalView(new TeachersContactModal())
