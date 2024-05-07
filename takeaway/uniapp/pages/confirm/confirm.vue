<template>
    <view style="padding: 20rpx;">
        <view class="box" style="background-color: antiquewhite; padding: 10rpx 20rpx;">
            <uni-icons type="sound" size="16" style="position: relative; top: 2rpx;" color="orange"></uni-icons>
            <text style="font-size: 24rpx; margin-left: 5rpx; color: orange;">Reminder: Please order appropriately to avoid waste</text>
        </view>
        
        <navigator url="/pages/address/address" class="box" style="margin: 20rpx 0;">
            <view v-if="addressId">
                <view style="margin-bottom: 10rpx; display: flex;">
                    <view style="flex: 1;">{{ address.address }}</view>
                    <uni-icons type="right" color="#666"></uni-icons>
                </view>
                <view style="color: #888; margin-bottom: 20rpx;">
                    <text>{{ address.user }}</text>
                    <text style="margin-left: 20rpx;">{{ address.phone }}</text>
                </view>
                <view style="display: flex;">
                    <view style="flex: 1; font-weight: bold;">Platform Delivery</view>
                    <view style="flex: 1; color: dodgerblue; text-align: right;">Deliver in 30 minutes</view>
                </view>
            </view>
            <view v-else>
                <uni-icons type="plus" size="18" style="position: relative; top: 4rpx;" color="dodgerblue"></uni-icons>
                <text style="margin-left: 5rpx; color: dodgerblue;">Please add a shipping address</text>
            </view>
        </navigator>
        
        <!-- Cart items and amount information -->
        <view class="box" style="margin: 20rpx 0;">
            <view style="margin-bottom: 20rpx; color: #666; font-size: 36rpx;">{{ business.name }}</view>
            
            <view>
                <view style="display: flex; grid-gap: 20rpx; margin-bottom: 20rpx;" v-for="item in cartList" :key="item.id">
                    <view style="width: 140rpx; height: 140rpx;">
                        <image :src="item.goods.img" style="width: 100%; height: 100%; display: block; border-radius: 10rpx;"></image>
                    </view>
                    <view style="flex: 1; display: flex; flex-direction: column; justify-content: space-between;">
                        <view>{{ item.goods.name }}</view>
                        <view style="color: #888;">x {{ item.num }}</view>
                    </view>
                    <view style="width: 150rpx; text-align: right; color: red; padding-top: 10rpx;">
                        ￥{{ item.goods.actualPrice }}
                    </view>
                </view>
            </view>
            <!-- Display discount and total amount information -->
            <view v-if="amount.discount">
                <view style="text-align: right;">
                    <text>Discount</text>
                    <text style="color: red;">￥{{ amount.discount }}</text>
                    <text style="margin-left: 20rpx;">Subtotal</text>
                    <text style="color: red; font-size: 36rpx; font-weight: bold;">￥{{ amount.actual }}</text>
                </view>
            </view>
        </view>
        <!-- Cart items and amount information -->
        
        <!-- Merchant commitments -->
        <view class="box" style="margin: 20rpx 0;">
            <view style="display: flex; margin-bottom: 10rpx;">
                <view style="flex: 1; font-weight: bold;">Merchant Commitments</view>
                <view style="flex: 1; text-align: right; color: #666;">After-sales worry-free · Food worry-free</view>
            </view>
            <view style="display: flex; margin-bottom: 10rpx;">
                <view style="flex: 1; font-weight: bold;">Privacy Protection</view>
                <view style="flex: 1; text-align: right; color: #666;">Number protection · Privacy worry-free</view>
            </view>
            <view style="display: flex; margin-bottom: 10rpx;">
                <view style="flex: 1; font-weight: bold;">Remarks</view>
                <navigator url="/pages/orderComment/orderComment" 
                    style="flex: 1; text-align: right; color: #999;">
                    <text v-if="comment">{{ comment }}</text>
                    <text v-else>Please fill in taste preferences</text>
                    <uni-icons type="right" color="#999" style="position: relative; top: 2rpx;"></uni-icons>
                </navigator>
            </view>
        </view>
        <!-- Merchant commitments -->
        
        <view class="box" style="margin-bottom: 110rpx;">
            <uni-data-checkbox v-model="payType" :localdata="range"></uni-data-checkbox>
        </view>
        
        <!-- Submit button -->
        <view v-if="amount.discount" class="box" style="position: fixed; bottom: 0; width: 100%; left: -40rpx;">
            <view style="text-align: right;">
                <text>Discount</text>
                <text style="color: red;">￥{{ amount.discount }}</text>
                <text style="margin-left: 20rpx;">Subtotal</text>
                <text style="color: red; font-size: 36rpx; font-weight: bold;">￥{{ amount.actual }}</text>
                <button size="mini" type="primary" style="margin-left: 20rpx; 
                    background-color: dodgerblue; border-color: dodgerblue; position: relative; top: 6rpx;" @click="addOrder">Submit Order</button>
            </view>
        </view>
        <!-- Submit button -->
        
    </view>
</template>

<script>
    export default {
        data() {
            return {
                businessId: 0,
                addressId: 0,
                comment: '',
                user: uni.getStorageSync('xm-user'),
                cartList: [],
                amount: {},
                business: {},
                address: {},
                payType: 'Alipay',
                range: [
                    { "value": 'Alipay',"text": "Alipay" },
                    { "value": 'WeChat Pay',"text": "WeChat Pay" },
                ]
            }
        },
        onShow() {
            // Get cached data
            let xmOrders = uni.getStorageSync('xm-orders')
            this.businessId = xmOrders.businessId || 0
            this.addressId = xmOrders.addressId || 0
            this.comment = xmOrders.comment || ''
            this.loadCart()
            this.loadAddress()
        },
        methods: {
            addOrder() {
                if (!this.addressId) {
                    uni.showToast({
                        icon: 'error',
                        title: 'Please select an address'
                    })
                    return
                }
                
                let form = { businessId: this.businessId, comment: this.comment, user: this.address.user, 
                address: this.address.address, phone: this.address.phone, payType: this.payType }
                this.$request.post('/orders/addOrder', form).then(res => {
                    if (res.code === '200') {
                      uni.removeStorageSync('xm-orders')//clean cache
                      uni.showToast({
                        icon: "success",
                        title: 'Operation successful'
                      })
                    setTimeout(() =>{
                        uni.switchTab({
                            url: '/pages/orders/orders'
                        })
                    }, 500)
                      
                    } else {
                      uni.showToast({
                        icon: "error",
                        title: res.msg
                      })
                    }
                  })
            },
            loadAddress() {
                this.$request.get('/address/selectById/' + this.addressId).then(res => {
                    this.address = res.data || {}
                })
            },
            loadCart() {
                this.$request.get('/cart/selectAll', { userId: this.user.id, businessId: this.businessId  }).then(res => {
                    this.cartList = res.data || []
                    if (this.cartList.length) {
                        this.business = this.cartList[0].business || {}
                    }
                })
                
                this.$request.get('/cart/calc', { userId: this.user.id, businessId: this.businessId }).then(res => {
                    this.amount = res.data || {}
                })
            },
        }
    }
</script>

<style>

</style>
