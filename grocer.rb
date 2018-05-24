require 'pry'

def consolidate_cart(cart)
  # code here
  consolidated = {}
  cart.each do |item|
    item.each do |product, info|
      if consolidated.keys.include?(product)
        #add count +1
        consolidated[product][:count] += 1
      else
        #add product hash
        consolidated[product] = info
        consolidated[product][:count] = 1
      end
    end
  end
  consolidated
end

def apply_coupons(cart, coupons)
  #check for coupons
  if coupons.empty?
    return cart
  end
  #initialize vars needed for items w/coupon
  new_key = ""
  value_wcoupon = {}
  new_cart = {}

  #add coupon counter key
  coupons.each do |coupon|
    coupon[:used] = 0
  end
  
  #check for items that you can apply coupons to
  cart.each do |product, info|
    coupons.each do |coupon|
      #check if coupon numbers and product numbers match, and product has matching coupon
      if coupon.values.include?(product) && info[:count] >= coupon[:num]
        info[:count] = info[:count] - coupon[:num]
        #mark one use for coupon
        coupon[:used] += 1
        #create new PRODUCT W/COUPON
        new_key = "#{coupon[:item]} W/COUPON"
        value_wcoupon = {
          :price => coupon[:cost], 
          :clearance => info[:clearance], 
          :count => coupon[:used]
        }
      end
    end
    new_cart[new_key] = value_wcoupon
  end
  #delete cart items with :count 0 ?
  # cart.delete_if do |product, info|
  #   info[:count] == 0
  # end
  cart.merge!(new_cart)
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |product, info|
    if info[:clearance]
      info[:price] *= 0.8
      info[:price] = info[:price].round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  total = 0.0
  cart = consolidate_cart(cart)
  apply_coupons(cart, coupons)
  apply_clearance(cart)

  #count total, shouldn't be this long but can't make it work
  prices = cart.values.collect do |item|
    #binding.pry
    if item[:count]
      item[:price]*item[:count]
    end
  end
  prices.compact!  
  prices.each do |i|
    total += i
    #binding.pry
  end

  #apply extra discount if total over 100
  if total > 100
    total *= 0.9
  end
  total.round(1)
end
