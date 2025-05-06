<template>
	<view style="padding: 40rpx;">
		<view style="padding: 20rpx; margin: 80rpx 0; background-color: #fff; box-shadow: 0 2rpx 10rpx rgba(0,0,0,.1); border-radius: 10rpx;">
			<view style="margin: 50rpx 30rpx; font-size: 40rpx;">欢迎注册</view>
			<uni-forms ref="form" :modelValue="form" :rules="rules" validateTrigger='blur'>
				<uni-forms-item name="username" required>
					<uni-easyinput prefixIcon="person" v-model="form.username" placeholder="请输入账号" />
				</uni-forms-item>
				<uni-forms-item name="password" required>
					<uni-easyinput prefixIcon="locked" v-model="form.password" placeholder="请输入密码" />
				</uni-forms-item>
				
				<!-- 凭证问题1 -->
				<view style="margin: 20rpx 0; font-size: 28rpx; color: #666;">凭证问题1</view>
				<uni-forms-item name="question1" required>
					<uni-easyinput v-model="form.question1" placeholder="请输入问题1" />
				</uni-forms-item>
				<uni-forms-item name="answer1" required>
					<uni-easyinput v-model="form.answer1" placeholder="请输入答案1" />
				</uni-forms-item>

				<!-- 凭证问题2 -->
				<view style="margin: 20rpx 0; font-size: 28rpx; color: #666;">凭证问题2</view>
				<uni-forms-item name="question2" required>
					<uni-easyinput v-model="form.question2" placeholder="请输入问题2" />
				</uni-forms-item>
				<uni-forms-item name="answer2" required>
					<uni-easyinput v-model="form.answer2" placeholder="请输入答案2" />
				</uni-forms-item>
				
				<uni-forms-item>
					<button @click="register()" style="background-color: #ffd100; border-color: #ffd100; 
						height: 70rpx; line-height: 70rpx;">注 册</button>
				</uni-forms-item>
				<uni-forms-item>
					<view style="text-align: right;">已有账号？去 <navigator style="display: inline-block; color: dodgerblue; 
						margin-left: 4rpx;" url="/pages/login/login">登录</navigator></view>
				</uni-forms-item>
			</uni-forms>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				form: {
					role: 'CUSTOMER',
					username: '',
					password: '',
					question1: '',
					answer1: '',
					question2: '',
					answer2: ''
				},
				rules: {
					username: {
						rules:[
							{
								required: true,
								errorMessage: '请输入账号',
							},
							{
								minLength: 3,
								maxLength: 10,
								errorMessage: '账号长度在 {minLength} 到 {maxLength} 个字符',
							}
						],
					},
					password: {
						rules:[
							{
								required: true,
								errorMessage: '请输入密码',
							},
							{
								minLength: 3,
								maxLength: 10,
								errorMessage: '密码长度在 {minLength} 到 {maxLength} 个字符',
							}
						],
					},
					question1: {
						rules:[
							{
								required: true,
								errorMessage: '请输入问题1',
							}
						],
					},
					answer1: {
						rules:[
							{
								required: true,
								errorMessage: '请输入答案1',
							}
						],
					},
					question2: {
						rules:[
							{
								required: true,
								errorMessage: '请输入问题2',
							}
						],
					},
					answer2: {
						rules:[
							{
								required: true,
								errorMessage: '请输入答案2',
							}
						],
					}
				}
			}
		},
		methods: {
			register() {
				this.$refs.form.validate().then(res=>{
					// 验证问题不能重复
					if (this.form.question1 === this.form.question2) {
						uni.showToast({
							icon: 'error',
							title: '两个问题不能相同'
						})
						return
					}
					
					// 构造提交的数据
					const submitData = {
						...this.form,
						question: JSON.stringify(
							[
							{
								question: this.form.question1,
								answer: this.form.answer1
							},
							{
								question: this.form.question2,
								answer: this.form.answer2
							}
						]
						)
					}
					
					// 删除临时字段
					delete submitData.question1
					delete submitData.question2
					delete submitData.answer1
					delete submitData.answer2
					
					this.$request.post('/register', submitData).then(res => {
						if (res.code === '200') {
							uni.showToast({
								icon: 'success',
								title: '注册成功'
							})
							
							setTimeout(() => {
								// 跳转登录页面
								uni.navigateTo({
									url: '/pages/login/login'
								})
							}, 500)
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
