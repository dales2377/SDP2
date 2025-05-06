<template>
	<view>
		<uni-segmented-control :current="current" :values="items" @clickItem="onClickItem" styleType="text"
			activeColor="#ff9900"></uni-segmented-control>
		<view style="padding: 20rpx;">
			<view class="box" v-for="item in ordersList" :key="item.id" style="margin-bottom: 10rpx;">
				<view style="display: flex; align-items: baseline; margin-bottom: 10rpx;">
					<navigator :url="'/pages/detail/detail?businessId=' + item.businessId"
						style="flex: 1; font-size: 32rpx; ">{{ item.businessName }}
						<uni-icons type="right" size="16" color="#666"
							style="position: relative; top: 2rpx;"></uni-icons>
					</navigator>
					<view style="font-size: 24rpx; color: #666;">{{ orderStatusMap[item.status] || item.status }}</view>
				</view>
				<view style="display: flex; align-items: center; grid-gap: 20rpx; margin-bottom: 10rpx;"  @click="goOrdersItem(item.id)">
					<view>
						<image style="display: block; width: 160rpx; height: 160rpx; border-radius: 10rpx;"
							:src="item.cover"></image>
					</view>
					<view style="flex: 1;">{{ item.name }}</view>
					<view>实付￥<text style="font-size: 36rpx; font-weight: bold; color: red;">{{ item.actual }}</text>
					</view>
				</view>
				<view style="display: flex; min-height: 40rpx;">
					<view style="flex: 1;">
						<view v-if="item.status === 'complete' || item.status === 'refunded'"
							@click="del(item.id)">
							<uni-icons type="trash" size="16" color="#666"
								style="position: relative; top: 2rpx;"></uni-icons>
							<text style="font-size: 24rpx; color: #666;">删除</text>
						</view>
					</view>
					<view style="flex: 1; text-align: right;">
						<uni-tag v-if="item.status === 'awaitpayment'" text="支付" size="mini" type="primary"
							@click="changeStatus(item, 'awaitshipping')"></uni-tag>
						<uni-tag v-if="item.status === 'awaitshipping'" text="申请退款" size="mini" type="error"
							@click="changeStatus(item, 'refunded')"></uni-tag>
						<uni-tag v-if="item.status === 'awaitreceiption'" text="确认收货" size="mini" type="warning"
							@click="changeStatus(item, 'awaitcomments')"></uni-tag>
						<uni-tag v-if="item.status === 'awaitcomments'" text="评价" size="mini" type="royal" @click="goComment(item.id)"></uni-tag>
					</view>
				</view>
			</view>

		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				current: 0,
				items: ['全部', '进行中', '待评价', '已退款'],
				ordersList: [],
				user: uni.getStorageSync('xm-user'),
				orderStatusMap: {
					'awaitpayment': '待支付',
					'awaitshipping': '待发货',
					'awaitreceiption': '待收货',
					'awaitcomments': '待评价',
					'refunded': '已退款',
					'complete': '已完成'
				}
			}
		},
		onShow() {
			this.loadOrders()
		},
		methods: {
			goComment(orderId) {
				uni.navigateTo({
					url: '/pages/comment/comment?orderId=' + orderId
				})
			},
			goOrdersItem(orderId) {
				uni.navigateTo({
					url: '/pages/ordersItem/ordersItem?orderId=' + orderId
				})
			},
			del(orderId) {
				this.$request.del('/orders/delete/' + orderId).then(res => {
					if (res.code === '200') {
						uni.showToast({
							icon: "success",
							title: '操作成功'
						})
						this.loadOrders()
					} else {
						uni.showToast({
							icon: "error",
							title: res.msg
						})
					}
				})
			},
			changeStatus(orders, status) {
				let form = JSON.parse(JSON.stringify(orders))
				form.status = status
				this.$request.put('/orders/update', form).then(res => {
					if (res.code === '200') {
						uni.showToast({
							icon: "success",
							title: '操作成功'
						})
						this.loadOrders()
					} else {
						uni.showToast({
							icon: "error",
							title: res.msg
						})
					}
				})
			},
			loadOrders() {
				let status = '全部'
				switch (this.current) {
					case 0:
						status = 'all';
						break
					case 1:
						status = 'progress';
						break
					case 2:
						status = 'awaitcomments';
						break
					case 3:
						status = 'refunded';
						break
				}
				this.$request.get('/orders/selectAll', {
					userId: this.user.id,
					status: status
				}).then(res => {
					this.ordersList = res.data || []
				})
			},
			onClickItem(e) {
				if (this.current != e.currentIndex) {
					this.current = e.currentIndex;
					this.loadOrders()
				}
			}
		}
	}
</script>

<style>

</style>