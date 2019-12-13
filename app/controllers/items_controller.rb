class ItemsController < ApplicationController
  before_action :set_item, only: [:edit, :update, :show, :show_user_item, :destroy, :image_edit]
  before_action :authenticate_user!, except: [:index, :show]



  def index 
    id = user_signed_in? ? current_user.id : nil
    @ladies_items = Item.get_ladies.buyable(id).recent10
    @mens_items = Item.get_mens.buyable(id).recent10
    @electronics_items = Item.get_electronics.buyable(id).recent10
    @hobbies_items = Item.get_hobbies.buyable(id).recent10
    @chanel_items = Brand.buyable_items("シャネル", id).recent10
    @louisvuitton_items = Brand.buyable_items("ルイヴィトン", id).recent10
    @supreme_items = Brand.buyable_items("スプリーム", id).recent10
    @nike_items = Brand.buyable_items("ナイキ", id).recent10
  end

  def category_find
    respond_to do |format| 
      parent = Category.find(params[:category_id])
      @children = parent.children
      format.json
    end
  end

  def brand_find
    respond_to do |format| 
      return nil if params[:keyword] == ""
      @brands = Brand.where(['name LIKE ?', "%#{params[:keyword]}%"] ).limit(5)
      format.json
    end
  end

  def new
    @item = Item.new
    10.times{@item.images.build}
    render layout: false
  end

  def create
    @item = current_user.items.new(item_params)
    @item.set_fee_profit unless @item.price == nil
    if @item.save
      redirect_to root_path
    else  
      10.times{@item.images.build}
      render :new, layout: false
    end
  end
 
  def edit
    @images = @item.images
    (10 - @images.length).times{@item.images.build}
    render layout: false
  end

  def update
    if @item.update(item_params)
      @item.set_fee_profit unless @item.price == nil
      redirect_to show_user_item_item_path(@item)
    else
      @images = @item.images
      (10 - @images.length).times{@item.images.build}
      render :edit, layout: false
    end
  end

  def show
    @user = @item.user
    @prefecture = Prefecture.find(@item.prefecture_id)
    @brand = Brand.find(@item.brand_id)
  end

  def show_user_item
    @brand = @item.brand
    @prefecture = Prefecture.find(@item.prefecture_id)
    @user = current_user
  end

  def destroy
    @item.destroy
    redirect_to root_path
  end

  private


  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    if params[:brand_name] == ""
      params.require(:item).permit(
        :name, 
        :item_text,
        :condition,
        :category_id,
        :prefecture_id,
        :delivery_fee,
        :days,
        :price,
        :delivery_method,
        :buyer_id,
        images_attributes: [:image, :id, :_destroy]
      ).merge(user_id: current_user.id)
    else 
      @brand = Brand.search(params[:brand_name])
      params.require(:item).permit(
        :name, 
        :item_text,
        :condition,
        :category_id,
        :prefecture_id,
        :delivery_fee,
        :days,
        :price,
        :delivery_method,
        :buyer_id,
        images_attributes: [:image, :id, :_destroy]  
      ).merge(user_id: current_user.id, brand_id: @brand.id)
    end
  end




end
