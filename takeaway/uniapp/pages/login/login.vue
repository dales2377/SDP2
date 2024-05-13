<template>
	<view style="padding: 40rpx;">
		<view style="padding: 20rpx; margin: 80rpx 0; background-color: #fff; box-shadow: 0 2rpx 10rpx rgba(0,0,0,.1); border-radius: 10rpx;">
			<view style="margin: 50rpx 30rpx; font-size: 40rpx;">Welcome</view>
			<uni-forms ref="form" :modelValue="form" :rules="rules" validateTrigger='blur'>
				<uni-forms-item name="username" required>
					<uni-easyinput prefixIcon="person" v-model="form.username" placeholder="please enter your username" />
				</uni-forms-item>
				<uni-forms-item name="password" required>
					<uni-easyinput prefixIcon="locked" v-model="form.password" placeholder="please enter your password" />
				</uni-forms-item>
				<uni-forms-item>
					<button @click="login()" style="background-color: #ffd100; border-color: #ffd100; height: 70rpx; line-height: 70rpx;">Login</button>
				</uni-forms-item>
				<!-- <uni-forms-item>
					<view style="text-align: right;">还没有账号？去 <navigator style="display: inline-block; color: dodgerblue; 
						margin-left: 4rpx;" url="/pages/register/register">注册</navigator></view>
				</uni-forms-item> -->
			</uni-forms>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				form: {
					role: 'USER'
				},
				rules: {
					// 对username字段进行必填验证
					username: {
						// username 字段的校验规则
						rules:[
							// 校验 username 不能为空
							{
								required: true,
								errorMessage: 'username is required',
							},
							// 对username字段进行长度验证
							{
								minLength: 3,
								maxLength: 10,
								errorMessage: 'username length between {minLength} to {maxLength} chars',
							}
						],
					},
					password: {
						rules:[
							{
								required: true,
								errorMessage: 'password is required',
							},
							{
								minLength: 3,
								maxLength: 10,
								errorMessage: 'password length between {minLength} to {maxLength} chars',
							}
						],
					}
				}
			}
		},
		methods: {
			login() {
				this.$refs.form.validate().then(res=>{
					this.$request.post('/login', this.form).then(res => {
						if (res.code === '200') {
							uni.showToast({
								icon: 'success',
								title: 'login success'
							})
							uni.setStorageSync('xm-user', res.data)
							
							// 跳转主页
							uni.switchTab({
								url: '/pages/index/index'
							})
						} else {
							uni.showToast({
								icon: 'error',
								title: res.msg
							})
						}
					})
				}).catch(err =>{
					console.log('表单错误信息：', err);
				})
			}
		}
	}
</script>

<style>

</style>
