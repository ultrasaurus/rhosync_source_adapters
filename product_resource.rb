 require 'rubygems'
 require 'active_resource'
 require 'rho_helper'
 
 class ProductResource < ActiveResource::Base
   include RhoHelper
   self.site = "http://productshop.heroku.com/"
   self.element_name = "product"
 end
