<template>
	<view style="padding: 40rpx;">
		<view style="padding: 20rpx; margin: 80rpx 0; background-color: #fff; box-shadow: 0 2rpx 10rpx rgba(0,0,0,.1); border-radius: 10rpx;">
			<view style="margin: 50rpx 30rpx; font-size: 40rpx;">找回密码</view>
			<uni-forms ref="form" :modelValue="form" :rules="rules" validateTrigger='blur'>
				<!-- 第一步：输入用户名 -->
				<template v-if="step === 1">
					<uni-forms-item name="username" required>
						<uni-easyinput prefixIcon="person" v-model="form.username" placeholder="请输入账号" />
					</uni-forms-item>
					<uni-forms-item>
						<button @click="getQuestions()" style="background-color: #ffd100; border-color: #ffd100; height: 70rpx; line-height: 70rpx;">下一步</button>
					</uni-forms-item>
				</template>

				<!-- 第二步：回答安全问题并设置新密码 -->
				<template v-if="step === 2">
					<view style="margin: 20rpx 0; font-size: 28rpx; color: #666;">请回答以下安全问题并设置新密码</view>
					
					<!-- 问题1 -->
					<view style="margin: 20rpx 0; font-size: 28rpx; color: #666;">问题1：{{questions[0].question}}</view>
					<uni-forms-item name="answer1" required>
						<uni-easyinput v-model="form.answer1" placeholder="请输入答案1" />
					</uni-forms-item>

					<!-- 问题2 -->
					<view style="margin: 20rpx 0; font-size: 28rpx; color: #666;">问题2：{{questions[1].question}}</view>
					<uni-forms-item name="answer2" required>
						<uni-easyinput v-model="form.answer2" placeholder="请输入答案2" />
					</uni-forms-item>

					<!-- 新密码 -->
					<uni-forms-item name="newPassword" required>
						<uni-easyinput type="password" prefixIcon="locked" v-model="form.newPassword" placeholder="请输入新密码" />
					</uni-forms-item>
					<uni-forms-item name="confirmPassword" required>
						<uni-easyinput type="password" prefixIcon="locked" v-model="form.confirmPassword" placeholder="请确认新密码" />
					</uni-forms-item>

					<uni-forms-item>
						<button @click="updatePassword()" style="background-color: #ffd100; border-color: #ffd100; height: 70rpx; line-height: 70rpx;">确认修改</button>
					</uni-forms-item>
				</template>

				<uni-forms-item>
					<view style="text-align: right;">
						<navigator style="display: inline-block; color: dodgerblue;" url="/pages/login/login">返回登录</navigator>
					</view>
				</uni-forms-item>
			</uni-forms>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				step: 1, // 当前步骤：1-输入用户名，2-回答问题并设置新密码
				questions: [], // 存储安全问题
				form: {
					username: '',
					answer1: '',
					answer2: '',
					newPassword: '',
					confirmPassword: ''
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
					answer1: {
						rules:[
							{
								required: true,
								errorMessage: '请输入答案1',
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
					},
					newPassword: {
						rules:[
							{
								required: true,
								errorMessage: '请输入新密码',
							},
							{
								minLength: 3,
								maxLength: 10,
								errorMessage: '密码长度在 {minLength} 到 {maxLength} 个字符',
							}
						],
					},
					confirmPassword: {
						rules:[
							{
								required: true,
								errorMessage: '请确认新密码',
							},
							{
								validateFunction: (rule, value, data, callback) => {
									if (value !== this.form.newPassword) {
										callback('两次输入的密码不一致')
									}
									return true
								}
							}
						],
					}
				}
			}
		},
		methods: {
			// 获取安全问题
			getQuestions() {
				this.$refs.form.validateField('username').then(res => {
					this.$request.post('/getQuestion', {
						userName: this.form.username
					}).then(res => {
						if (res.code === '200') {
							this.questions = res.data
							this.step = 2
						} else {
							uni.showToast({
								icon: 'error',
								title: res.msg
							})
						}
					})
				})
			},
			
			// 更新密码
			updatePassword() {
				this.$refs.form.validate().then(res => {
					const submitData = {
						userName: this.form.username,
						password: this.form.newPassword,
						question: [
							{
								question: this.questions[0].question,
								answer: this.form.answer1
							},
							{
								question: this.questions[1].question,
								answer: this.form.answer2
							}
						]
					}
					
					this.$request.post('/updatePasswordByQuestion', submitData).then(res => {
						if (res.code === '200') {
							uni.showToast({
								icon: 'success',
								title: '密码修改成功'
							})
							
							setTimeout(() => {
								uni.navigateTo({
									url: '/pages/login/login'
								})
							}, 1500)
						} else {
							uni.showToast({
								icon: 'error',
								title: res.msg
							})
						}
					})
				})
			}
		}
	}
</script>

<style>

</style> 