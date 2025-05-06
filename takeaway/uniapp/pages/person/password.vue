<template>
	<view style="padding: 20rpx;">
		<view class="box">
			<uni-forms :modelValue="form" :rules="rules" ref="formRef" label-width="140rpx" label-align="right">
				<uni-forms-item label="旧密码" name="password">
					<uni-easyinput type="password" v-model="form.password" placeholder="请输入旧密码" />
				</uni-forms-item>
				<uni-forms-item label="新密码" name="newPassword">
					<uni-easyinput type="password" v-model="form.newPassword" placeholder="请输入新密码" />
				</uni-forms-item>
				<uni-forms-item label="确认密码" name="confirmPassword">
					<uni-easyinput type="password" v-model="form.confirmPassword" placeholder="请再次输入新密码" />
				</uni-forms-item>
				<uni-forms-item>
					<button type="primary" size="mini" @click="save">保 存</button>
				</uni-forms-item>
			</uni-forms>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
        user: uni.getStorageSync('xm-user'),
				form: {
					password: '',
					newPassword: '',
					confirmPassword: ''
				},
				// 表单校验规则
				rules: {
					password: {
						rules: [{
							required: true,
							errorMessage: '请输入旧密码'
						}]
					},
					newPassword: {
						rules: [{
							required: true,
							errorMessage: '请输入新密码'
						}]
					},
					confirmPassword: {
						rules: [{
							required: true,
							errorMessage: '请再次输入新密码'
						}]
					}
				}
			}
		},
    onLoad() {
			this.form = JSON.parse(JSON.stringify(this.user))
			this.avatar = [{
				url: this.user.avatar
			}]
		},
		methods: {
			// 保存修改密码
			save() {
				this.$refs.formRef.validate().then(res => {
					// 校验确认密码是否一致
					if(this.form.newPassword !== this.form.confirmPassword) {
						uni.showToast({
							icon: 'none',
							title: '两次输入的密码不一致'
						})
						return
					}
					// 调用修改密码接口
					this.$request.put('/updatePassword', this.form).then(res => {
						if(res.code === '200') {
							uni.showToast({
								icon: 'success',
								title: '修改成功'
							})
							// 清空表单
							this.form = {
								password: '',
								newPassword: '',
								confirmPassword: ''
							}
						} else {
							uni.showToast({
								icon: 'error',
								title: res.msg
							})
						}
					})
				}).catch(err => {
					console.log('表单错误:', err);
				})
			}
		}
	}
</script>

<style>
</style>
