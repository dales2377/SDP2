<template>
  <div class="container">
    <div style="width: 400px; padding: 30px; background-color: white; border-radius: 5px;">
      <div style="text-align: center; font-size: 20px; margin-bottom: 20px; color: #333">欢迎使用</div>
      <el-form :model="form" :rules="rules" ref="formRef">
        <el-form-item prop="username">
          <el-input prefix-icon="el-icon-user" placeholder="请输入账号" v-model="form.username"></el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input prefix-icon="el-icon-lock" placeholder="请输入密码" show-password  v-model="form.password"></el-input>
        </el-form-item>
        <el-form-item prop="role">
          <el-radio-group v-model="form.role">
            <el-radio label="ADMIN">管理员</el-radio>
            <el-radio label="BUSINESS">商家</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item>
          <el-button style="width: 100%; background-color: #333; border-color: #333; color: white" @click="login">登 录</el-button>
        </el-form-item>
        <div style="display: flex; align-items: center">
          <div style="flex: 1"></div>
          <div style="flex: 1; text-align: right">
            <a href="javascript:;" @click="showForgotPassword" v-if="form.role === 'BUSINESS'">找回密码</a>
            <span v-else>&nbsp;</span>
            <span style="margin: 0 10px">|</span>
            <a href="/register">商家注册</a>
          </div>
        </div>
      </el-form>
    </div>

    <!-- 找回密码对话框 -->
    <el-dialog title="找回密码" :visible.sync="forgotPasswordVisible" width="500px" :close-on-click-modal="false">
      <el-form :model="forgotForm" :rules="forgotRules" ref="forgotFormRef" label-width="100px">
        <!-- 第一步：输入用户名 -->
        <template v-if="forgotStep === 1">
          <el-form-item label="账号" prop="username">
            <el-input v-model="forgotForm.username" placeholder="请输入账号"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="getQuestions" style="width: 100%">下一步</el-button>
          </el-form-item>
        </template>

        <!-- 第二步：回答安全问题并设置新密码 -->
        <template v-if="forgotStep === 2">
          <div style="margin-bottom: 20px; color: #666;">请回答以下安全问题并设置新密码</div>
          
          <!-- 问题1 -->
          <div style="margin: 10px 0; color: #666;">问题1：{{questions[0].question}}</div>
          <el-form-item label="答案1" prop="answer1">
            <el-input v-model="forgotForm.answer1" placeholder="请输入答案1"></el-input>
          </el-form-item>

          <!-- 问题2 -->
          <div style="margin: 10px 0; color: #666;">问题2：{{questions[1].question}}</div>
          <el-form-item label="答案2" prop="answer2">
            <el-input v-model="forgotForm.answer2" placeholder="请输入答案2"></el-input>
          </el-form-item>

          <!-- 新密码 -->
          <el-form-item label="新密码" prop="newPassword">
            <el-input type="password" v-model="forgotForm.newPassword" placeholder="请输入新密码"></el-input>
          </el-form-item>
          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input type="password" v-model="forgotForm.confirmPassword" placeholder="请确认新密码"></el-input>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="updatePassword" style="width: 100%">确认修改</el-button>
          </el-form-item>
        </template>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "Login",
  data() {
    // 确认密码验证
    let validateConfirmPassword = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请再次输入密码'));
      } else if (value !== this.forgotForm.newPassword) {
        callback(new Error('两次输入密码不一致!'));
      } else {
        callback();
      }
    }
    return {
      form: { role: 'ADMIN' },
      rules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
        ]
      },
      // 找回密码相关数据
      forgotPasswordVisible: false,
      forgotStep: 1,
      questions: [],
      forgotForm: {
        username: '',
        answer1: '',
        answer2: '',
        newPassword: '',
        confirmPassword: ''
      },
      forgotRules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
          { min: 3, max: 10, message: '长度在3到10个字符内', trigger: 'blur' }
        ],
        answer1: [
          { required: true, message: '请输入答案1', trigger: 'blur' }
        ],
        answer2: [
          { required: true, message: '请输入答案2', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 8, max: 16, message: '长度在8到16个字符内', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请确认新密码', trigger: 'blur' },
          { validator: validateConfirmPassword, trigger: 'blur' }
        ]
      }
    }
  },
  created() {

  },
  methods: {
    login() {
      this.$refs['formRef'].validate((valid) => {
        if (valid) {
          // 验证通过
          this.$request.post('/login', this.form).then(res => {
            if (res.code === '200') {
              localStorage.setItem("xm-user", JSON.stringify(res.data))  // 存储用户数据
              this.$router.push('/')  // 跳转主页
              this.$message.success('登录成功')
            } else {
              this.$message.error(res.msg)
            }
          })
        }
      })
    },
    // 显示找回密码对话框
    showForgotPassword() {
      this.forgotPasswordVisible = true
      this.forgotStep = 1
      this.forgotForm = {
        username: '',
        answer1: '',
        answer2: '',
        newPassword: '',
        confirmPassword: ''
      }
      this.questions = []
    },
    // 获取安全问题
    getQuestions() {
      this.$refs['forgotFormRef'].validateField('username', (valid) => {
        if (!valid) {
          this.$request.post('/getQuestion', {
            userName: this.forgotForm.username
          }).then(res => {
            if (res.code === '200') {
              this.questions = res.data
              this.forgotStep = 2
            } else {
              this.$message.error(res.msg)
            }
          })
        }
      })
    },
    // 更新密码
    updatePassword() {
      this.$refs['forgotFormRef'].validate((valid) => {
        if (valid) {
          const submitData = {
            userName: this.forgotForm.username,
            password: this.forgotForm.newPassword,
            question: [
              {
                question: this.questions[0].question,
                answer: this.forgotForm.answer1
              },
              {
                question: this.questions[1].question,
                answer: this.forgotForm.answer2
              }
            ]
          }
          
          this.$request.post('/updatePasswordByQuestion', submitData).then(res => {
            if (res.code === '200') {
              this.$message.success('密码修改成功')
              this.forgotPasswordVisible = false
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
  text-decoration: none;
}
a:hover {
  text-decoration: underline;
}
</style>