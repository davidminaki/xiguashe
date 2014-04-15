#encoding: utf-8
class Cpanel::ProductsController < Cpanel::ApplicationController

  include ProductsHelper

  before_filter :require_admin

  before_filter :find_by_id, only: [:show, :edit, :show, :update, :destroy]

	def index
    @products = Product.short.includes(:user).search_in_cpanel(params[:search]).paginate(page: params[:page])
	end

	def show

	end

  def edit

  end

	def update

    if @product.update_attributes(params[:product])
      redirect_to cpanel_product_path(@product), notice: t(:update_success)
    end
		
	end

	def destroy

    @product.destroy

    redirect_to cpanel_products_path, notice: t(:delete_success)
	end


  private 

  def find_product(really_id, source)
    product = Product.by_really_id(really_id).by_source(source).first
  end

  def find_by_id
    @product = Product.find(params[:id])
  end

	
end
