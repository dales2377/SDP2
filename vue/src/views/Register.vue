<template>
  <div class="container">
    <div style="width: 400px; padding: 30px; background-color: white; border-radius: 5px;">
      <div style="text-align: center; font-size: 20px; margin-bottom: 20px; color: #333">欢迎注册</div>
      <el-form :model="form" :rules="rules" ref="formRef">
        <el-form-item prop="username">
          <el-input prefix-icon="el-icon-user" placeholder="请输入账号" v-model="form.username"></el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input prefix-icon="el-icon-lock" placeholder="请输入密码" show-password  v-model="form.password"></el-input>
        </el-form-item>
        <el-form-item prop="confirmPass">
          <el-input prefix-icon="el-icon-lock" placeholder="请确认密码" show-password  v-model="form.confirmPass"></el-input>
        </el-form-item>

        <!-- 凭证问题1 -->
        <div style="margin: 15px 0; font-size: 14px; color: #666;">凭证问题1</div>
        <el-form-item prop="question1">
          <el-input placeholder="请输入问题1" v-model="form.question1"></el-input>
        </el-form-item>
        <el-form-item prop="answer1">
          <el-input placeholder="请输入答案1" v-model="form.answer1"></el-input>
        </el-form-item>

        <!-- 凭证问题2 -->
        <div style="margin: 15px 0; font-size: 14px; color: #666;">凭证问题2</div>
        <el-form-item prop="question2">
          <el-input placeholder="请输入问题2" v-model="form.question2"></el-input>
        </el-form-item>
        <el-form-item prop="answer2">
          <el-input placeholder="请输入答案2" v-model="form.answer2"></el-input>
        </el-form-item>

        <el-form-item>
          <el-button style="width: 100%; background-color: #333; border-color: #333; color: white" @click="register">注 册</el-button>
        </el-form-item>
        <div style="display: flex; align-items: center">
          <div style="flex: 1"></div>
          <div style="flex: 1; text-align: right">
            已有账号？请 <a href="/login">登录</a>
          </div>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script>
export default {
  name: "Register",
  data() {
    let validateConfirmPass = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请再次输入密码'));
      } else if (value !== this.form.password) {
        callback(new Error('两次输入密码不一致!'));
      } else {
        callback();
      }
    }
    return {
      form: { 
        role: 'BUSINESS',
        username: '',
        password: '',
        confirmPass: '',
        question1: '',
        answer1: '',
        question2: '',
        answer2: ''
      },
      rules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
          { min:3, max: 10, message: '长度在3到10个字符内', trigger: 'blur'}
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min:8, max: 16, message: '长度在8到16个字符内', trigger: 'blur'}
        ],
        confirmPass: [
          { required: true, message: '请确认密码', trigger: 'blur' },
          { min:8, max: 16, message: '长度在8到16个字符内', trigger: 'blur'},
          { validator: validateConfirmPass, trigger: 'blur'}
        ],
        question1: [
          { required: true, message: '请输入问题1', trigger: 'blur' }
        ],
        answer1: [
          { required: true, message: '请输入答案1', trigger: 'blur' }
        ],
        question2: [
          { required: true, message: '请输入问题2', trigger: 'blur' }
        ],
        answer2: [
          { required: true, message: '请输入答案2', trigger: 'blur' }
        ]
      }
    }
  },
  created() {

  },
  methods: {
    register() {
      this.$refs['formRef'].validate((valid) => {
        if (valid) {
          // 验证问题不能重复
          if (this.form.question1 === this.form.question2) {
            this.$message.error('两个问题不能相同')
            return
          }

          // 构造提交的数据
          const submitData = {
            ...this.form,
            question: JSON.stringify([
              {
                question: this.form.question1,
                answer: this.form.answer1
              },
              {
                question: this.form.question2,
                answer: this.form.answer2
              }
            ])
          }
          
          // 删除临时字段
          delete submitData.question1
          delete submitData.question2
          delete submitData.answer1
          delete submitData.answer2
          delete submitData.confirmPass

          // 验证通过
          this.$request.post('/register', submitData).then(res => {
            if (res.code === '200') {
              this.$router.push('/login')  // 跳转登录
              this.$message.success('成功注册，请登录')
            } else {
              this.$message.error(res.msg)
            }
          })
        }
      })
    }
  }
}
</script>

<style scoped>
.container {
  height: 100vh;
  overflow: hidden;
  background-image: url("@/assets/imgs/bg.jpg");
  background-size: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #666;
}
a {
  color: #2a60c9;
}
</style>