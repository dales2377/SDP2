<template>
    <view style="padding: 20rpx;">
        <!-- Business information -->
        <view class="box" style="display: flex;">
            <view style="flex: 1; display: flex; flex-direction: column; justify-content: space-between;">
                <view style="font-size: 36rpx; font-weight: bold;">{{ business.name || '' }}</view>
                <view>
                    <text style="padding-right: 10rpx; border-right: 2rpx solid #ccc;">Platform Delivery</text>
                    <text style="padding: 0 10rpx; border-right: 2rpx solid #ccc;">Free Delivery</text>
                    <text style="padding: 0 10rpx;">Deliver in 30 minutes</text>
                </view>
                <view>
                    Address: {{ business.address || '' }}
                </view>
                <view>
                    Contact Number: {{ business.phone || '' }}
                </view>
            </view>

            <view style="width: 200rpx; height: 200rpx;">
                <image :src="business.avatar" style="width: 100%; height: 100%; border-radius: 50%;"></image>
            </view>
        </view>
        <!-- End of business information -->

        <!-- Business's categorized product list -->
        <view style="margin: 20rpx 0;">
            <view
                style="background-color: #fff; display: flex; border-radius: 10rpx; overflow: hidden; margin-bottom: 10rpx;">
                <view style="padding: 10rpx; background-color: #ffd100;">All Products</view>
                <view style="padding: 10rpx;">Reviews</view>
            </view>

            <!-- Category product display -->
            <view style="display: flex; background-color: #fff; border-radius: 10rpx; padding: 10rpx;">
                <view style="width: 200rpx; text-align: center;">
                    <view v-for="item in categoryList" :key="item.id" class="category-item"
                        :class="{ 'category-active' : item.id === activeCategoryId }" @click="loadGoods(item.id)">
                        {{ item.name }}
                    </view>
                </view>
                
                <scroll-view scroll-y="true" style="height: calc(100vh - 480rpx);">
                    <!-- Product list start -->
                    <view style="padding: 20rpx;">
                        <view style="display: flex; grid-gap: 20rpx; margin-bottom: 20rpx;" v-for="item in goodsList" :key="item.id">
                            <view style="width: 200rpx; height: 200rpx;">
                                <image :src="item.img" style="width: 200rpx; height: 200rpx; border-radius: 10rpx; display: block;"></image>
                            </view>
                            <view style="flex: 1; display: flex; flex-direction: column; justify-content: space-between;">
                                <view style="font-size: 32rpx; font-weight: bold;">{{ item.name }}</view>
                                <view style="font-size: 24rpx;">{{ item.descr }}</view>
                                <view>
                                    <text class="mini-btn">{{ item.discount }}% off</text>
                                    <text style="font-size: 24rpx; margin-left: 10rpx;">Sold 30</text>
                                </view>
                                <view>
                                    <text style="text-decoration: line-through;">￥{{ item.price }}</text>
                                    <text style="color: orangered; margin-left: 10rpx;">￥{{ item.actualPrice }}</text>
                                    <text class="mini-btn" style="margin-left: 5rpx;">Final Price</text>
                                </view>
                                <view>
                                    <text class="mini-btn-fill" @click="addCart(item)">Buy</text>
                                </view>
                            </view>
                        </view>
                    </view>
                    <!-- Product list end -->
                </scroll-view>
                
            </view>
        </view>
        <!-- End of business's categorized product list -->
        
        <uni-goods-nav :fill="true"  :options="options" :buttonGroup="buttonGroup"  @click="onClick" @buttonClick="buttonClick" />

        <uni-popup ref="popup" type="bottom" background-color="#fff">
          <scroll-view style="max-height: 70vh;" scroll-y="true">
            <view style="padding: 40rpx 40rpx 140rpx 40rpx;">
              <view style="text-align: right; margin-bottom: 10rpx; color: #999;" v-if="cartList.length">
                <uni-icons style="position: relative; top: 4rpx;" type="trash" size="16"
                 color="#999" @click="deleteAll"></uni-icons>
                 <text @click="deleteAll">Clear </text>
              </view>
              <view v-for="(item, index) in cartList" :key="index" style="display: flex; margin-bottom: 20rpx;" v-if="item.goods">
                <view style="width: 100rpx; height: 100rpx;">
                  <image style="width: 100%; height: 100%; display: inline-block;" :src="item.goods.img"></image>
                </view>
                <view style="flex: 1; margin-left: 20rpx; display: flex; flex-direction: column; justify-content: space-around;">
                  <view style="flex: 1;">{{ item.goods.name }}</view>
                  <view style="flex: 1; color: red; display: flex; align-items: flex-end;">
                    <view style="flex: 1;">￥{{ item.goods.actualPrice }}</view>
                    <view style="flex: 1; display: flex; justify-content: right;">
                      <uni-number-box :min="1" v-model="item.num" @change="updateCart(item)"></uni-number-box>
                    </view>
                  </view>
                </view>
              </view>
              <view style="margin-top: 40rpx; text-align: right;" v-if="amount.amount">Total Amount: <text>￥{{ amount.amount }}</text></view>
              <view style="margin-top: 10rpx; text-align: right;" v-if="amount.discount">Discount Amount: <text style="color: red;">-￥{{ amount.discount }}</text></view>
              <view style="margin-top: 10rpx; text-align: right;" v-if="amount.actual">Total Payable Amount: <text style="color: red; font-size: 32rpx;">￥{{ amount.actual }}</text></view>
            </view>
          </scroll-view>
        </uni-popup>

    </view>
</template>

<script>
    export default {
        data() {
            return {
                businessId: 0,
                business: {},
                categoryList: [],
                activeCategoryId: 0,
                goodsList: [],
                options: [
                    {
                        icon: 'cart',
                        text: 'Cart',
                        info: 0
                    }
                ],
                buttonGroup: [
                    {
                        text: 'Buy Now',
                        backgroundColor: 'linear-gradient(90deg, #FE6035, #EF1224)',
                        color: '#fff'
                    }
                ],
                user: uni.getStorageSync('xm-user'),
                cartList: [],
                amount: {}
            }
        },
        onShow() {
            let allPages = getCurrentPages() // Get instances of the current page stack
            let lastPages = allPages.length - 1 // Get the index of the second last element
            let option = allPages[lastPages].options // Get the parameters passed by the previous page
            this.businessId = option.businessId
            this.load()
            this.loadCart()
        },
        methods: {
            buttonClick() {
              if (this.cartList.length === 0) {
                  uni.showToast({
                    icon: 'error',
                    title: 'Please select a product'
                  })
                  return
              }
              let xmOrders = uni.getStorageSync('xm-orders') || {}
              xmOrders.businessId = this.businessId
              uni.setStorageSync('xm-orders', xmOrders)
              uni.navigateTo({
                url: '/pages/confirm/confirm',
              })
             
            },
            deleteAll() {
                this.$request.del('/cart/deleteByBusiness/' + this.businessId + '/' + this.user.id).then(res => {
                    if (res.code === '200') {
                        uni.showToast({
                            icon: 'success',
                            title: 'Operation successful'
                        })
                        this.loadCart()
                    } else {
                        uni.showToast({
                            icon: 'error',
                            title: res.msg
                        })
                    }
                })
            },
            updateCart(cart) {
                this.$request.put('/cart/update', cart).then(res => {
                    if (res.code === '200') {
                        this.loadCart()
                    } else {
                        uni.showToast({
                            icon: 'error',
                            title: res.msg
                        })
                    }
                })
            },
            onClick() {
                // Triggered when the shopping cart icon is clicked
                this.$refs.popup.open('bottom')
            },
            loadCart() {
                this.$request.get('/cart/selectAll', { userId: this.user.id, businessId: this.businessId  }).then(res => {
                    this.cartList = res.data || []
                    this.options[0].info = this.cartList.length
                })
                
                this.$request.get('/cart/calc', { userId: this.user.id, businessId: this.businessId }).then(res => {
                    this.amount = res.data || {}
                })
            },
            addCart(goods) {
                this.$request.post('/cart/add', { goodsId: goods.id, num: 1, businessId: this.businessId, userId: this.user.id }).then(res => {
                    if (res.code === '200') {
                        uni.showToast({
                            icon: 'success',
                            title: 'Added successfully'
                        })
                        this.loadCart()
                    } else {
                        uni.showToast({
                            icon: 'error',
                            title: res.msg
                        })
                    }
                })
            },
            load() {
                this.$request.get('/business/selectById/' + this.businessId).then(res => {
                    this.business = res.data || {}
                })

                this.$request.get('/category/selectAll', {
                    businessId: this.businessId
                }).then(res => {
                    this.categoryList = res.data || []
                    this.activeCategoryId = this.categoryList.length > 0 ? this.categoryList[0].id : 0
                    this.loadGoods(this.activeCategoryId)
                })
            },
            loadGoods(categoryId) {
                this.activeCategoryId = categoryId
                this.$request.get('/goods/selectAll', {
                    categoryId: categoryId
                }).then(res => {
                    this.goodsList = res.data || []
                })
            }
        }
    }
</script>

<style>
    .category-item {
        padding: 15rpx;
        background-color: #eee;
        border-bottom: 2rpx solid #fff;
    }

    .category-active {
        background-color: #fff;
        color: orange;
        border-left: 5rpx solid orange;
    }

    .mini-btn {
        border: 2rpx solid orangered;
        padding: 0 4rpx;
        font-size: 22rpx;
        color: orangered;
        border-radius: 5rpx;
        font-weight: bold;
    }

    .mini-btn-fill {
        background-color: orange;
        padding: 0 4rpx;
        color: #fff;
        font-size: 24rpx;
        border-radius: 5rpx;
    }
</style>
