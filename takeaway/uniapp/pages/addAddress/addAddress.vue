<template>
    <view style="padding: 20rpx;">
        <view class="box">
            <uni-forms :modelValue="form" :rules="rules" ref="formRef" label-width="160rpx" label-align="right">
              <uni-forms-item label="Address Information" name="address" required>
                <uni-easyinput type="textarea" v-model="form.address" placeholder="Please enter address" />
              </uni-forms-item>
              <uni-forms-item label="Contact Person" name="user" required>
                <uni-easyinput type="text" v-model="form.user" placeholder="Please enter contact person" />
              </uni-forms-item>
              <uni-forms-item label="Contact Number" name="phone" required>
                <uni-easyinput type="text" v-model="form.phone" placeholder="Please enter contact number" />
              </uni-forms-item>
            
              <uni-forms-item>
                <button type="primary" size="mini" @click="saveAddress">Save</button>
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
                form: {},
                rules: {
                  address: {
                    rules: [{
                      required: true,
                      errorMessage: 'Please fill in the address',
                    }]
                  },
                  user: {
                    rules: [{
                      required: true,
                      errorMessage: 'Please fill in the contact person',
                    }]
                  },
                  phone: {
                    rules: [{
                      required: true,
                      errorMessage: 'Please fill in the contact number',
                    }]
                  }
                }
            }
        },
        onLoad(option) {
            let addressId = option.addressId || 0
            
            if (addressId > 0) {
                this.$request.get('/address/selectById/' + addressId).then(res => {
                    this.form = res.data || {}
                })
            }
        },
        methods: {
            saveAddress() {
                // Validation
                this.$refs.formRef.validate().then(res => {
                  this.$request.request({
                      method: this.form.id ? 'PUT' : 'POST',
                      url: this.form.id ? '/address/update' : '/address/add',
                      data: this.form
                  }).then(res => {
                    if (res.code === '200') {
                      uni.showToast({
                        title: 'Operation successful'
                      })
                      uni.navigateBack()
                    } else {
                      uni.showToast({
                        icon: 'error',
                        title: res.msg
                      })
                    }
                  })
                }).catch(err => {
                  console.log('err', err);
                })  
            }
        }
    }
</script>

<style>

</style>
