<template>
  <div>
    <div class="search">
      <el-input placeholder="请输入账号查询" style="width: 200px" v-model="username"></el-input>
      <el-input placeholder="请输入名称" style="width: 200px; margin-left: 10px" v-model="name"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="operation">
      <el-button type="primary" plain @click="handleAdd">新增</el-button>
      <el-button type="danger" plain @click="delBatch">批量删除</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" strip @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="序号" width="70" align="center" sortable></el-table-column>
        <el-table-column prop="username" label="账号"></el-table-column>
        <el-table-column prop="name" label="姓名"></el-table-column>
        <el-table-column prop="phone" label="电话"></el-table-column>
        <el-table-column prop="email" label="邮箱"></el-table-column>
        <el-table-column label="头像">
          <template v-slot="scope">
            <div style="display: flex; align-items: center">
              <el-image style="width: 40px; height: 40px; border-radius: 50%" v-if="scope.row.avatar"
                        :src="scope.row.avatar" :preview-src-list="[scope.row.avatar]"></el-image>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="role" label="角色"></el-table-column>
        <el-table-column prop="jy" label="状态">
          <template v-slot="scope">
            <el-tag type="success" v-if="scope.row.isActive == 1">启用</el-tag>
            <el-tag type="danger" v-if="scope.row.isActive == 0">禁用</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="300">
          <template v-slot="scope">
            <el-button size="mini" type="primary" plain @click="handleEdit(scope.row)">编辑</el-button>
            <el-button size="mini" type="danger" :disabled="scope.row.username === 'admin'" plain @click="del(scope.row.id)">删除</el-button>
            <el-button size="mini" type="warning" plain @click="resetPassword(scope.row.id)">重置密码</el-button>
            <el-button size="mini" :type="scope.row.isActive == 1 ? 'danger' : 'success'" plain 
                       @click="handleToggleStatus(scope.row)"
                       :disabled="scope.row.username === 'admin'">
              {{ scope.row.isActive == 1 ? '禁用' : '启用' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
            background
            @current-change="handleCurrentChange"
            :current-page="pageNum"
            :page-sizes="[5, 10, 20]"
            :page-size="pageSize"
            layout="total, prev, pager, next"
            :total="total">
        </el-pagination>
      </div>
    </div>


    <el-dialog title="用户" :visible.sync="fromVisible" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="form" label-width="100px" style="padding-right: 50px" :rules="rules" ref="formRef">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="用户名"></el-input>
        </el-form-item>
        <el-form-item label="姓名" prop="name">
          <el-input v-model="form.name" placeholder="姓名"></el-input>
        </el-form-item>
        <el-form-item label="电话" prop="phone">
          <el-input v-model="form.phone" placeholder="电话"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="邮箱"></el-input>
        </el-form-item>
        <el-form-item label="头像">
          <el-upload
              class="avatar-uploader"
              :action="$baseUrl + '/files/upload'"
              :headers="{ token: user.token }"
              list-type="picture"
              :on-success="handleAvatarSuccess"
          >
            <el-button type="primary">上传头像</el-button>
          </el-upload>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button @click="fromVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>


  </div>
</template>

<script>
export default {
  name: "ADMIN",
  data() {
    return {
      role: 'ADMIN',
      tableData: [],  // data in table
      pageNum: 1,   // default page
      pageSize: 10,  // data number n each page
      total: 0,
      username: null,
      name: null,
      fromVisible: false,
      form: {},
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      rules: {
        username: [
          {required: true, message: '请输入账号', trigger: 'blur'},
        ],
        name: [
          {required: true, message: '请输入名称', trigger: 'blur'},
        ],
        password: [
          {required: true, message: '请输入密码', trigger: 'blur'},
        ]
      },
      ids: []
    }
  },
  created() {
    this.load(1)
  },
  methods: {
    handleAdd() {   // add new data
      this.form = {}  // clear from after submit
      this.fromVisible = true   // show windows
    },
    handleEdit(row) {   // edit
      this.form = JSON.parse(JSON.stringify(row))  // 给form对象赋值  注意要深拷贝数据
      this.fromVisible = true   // show windows
    },
    save() {   // trigger of update or add
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.$request({
            url: this.form.id ? '/user/update' : '/user/add',
            method: this.form.id ? 'PUT' : 'POST',
            data: {
              ...this.form,
              role: this.role
            }
          }).then(res => {
            if (res.code === '200') {  // save success
              this.$message.success('保存成功')
              this.load(1)
              this.fromVisible = false
            } else {
              this.$message.error(res.msg)  // show error
            }
          })
        }
      })
    },
    del(id) {   // // delete single data
      this.$confirm('您确定删除吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/user/delete/' + id).then(res => {
          if (res.code === '200') {   // done
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // show error msg
          }
        })
      }).catch(() => {
      })
    },
    handleSelectionChange(rows) {   // select all
      this.ids = rows.map(v => v.id)
    },
    delBatch() {   // batch delete
      if (!this.ids.length) {
        this.$message.warning('请选择数据')
        return
      }
      this.$confirm('您确定批量删除这些数据吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/user/delete/batch', {data: this.ids}).then(res => {
          if (res.code === '200') {   // done
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)  // or error
          }
        })
      }).catch(() => {
      })
    },
    load(pageNum) {  // divide to into different page
      if (pageNum) this.pageNum = pageNum
      this.$request.get('/user/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          username: this.username,
          name: this.name,
          role: this.role
        }
      }).then(res => {
        this.tableData = res.data?.list
        this.total = res.data?.total
      })
    },
    reset() {
      this.username = null
      this.name = null
      this.load(1)
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    },
    handleAvatarSuccess(response, file, fileList) {
      // way to upload picture
      this.form.avatar = response.data
    },
    handleLicenseSuccess(response, file, fileList) {
      this.form.license = response.data
    },
    // 重置密码方法
    resetPassword(id) {
      this.$confirm('确定要重置该用户的密码吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$request.post('/user/resetPassword', { id: id }).then(res => {
          if (res.code === '200') {
            this.$message.success('密码重置成功')
          } else {
            this.$message.error(res.msg)
          }
        })
      }).catch(() => {
        this.$message.info('已取消重置')
      })
    },
    // 处理禁用/启用状态切换
    handleToggleStatus(row) {
      // 如果是admin账号，不允许操作
      if (row.username === 'admin') {
        this.$message.warning('admin账号不允许禁用/启用')
        return
      }
      
      const action = row.isActive == 1 ? '禁用' : '启用'
      this.$confirm(`确定要${action}该管理员吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$request({
          url: '/user/update',
          method: 'PUT',
          data: {
            ...row,
            isActive: row.isActive == 1 ? 0 : 1
          }
        }).then(res => {
          if (res.code === '200') {
            this.$message.success(`${action}成功`)
            this.load(1)  // 刷新列表
          } else {
            this.$message.error(res.msg)
          }
        })
      }).catch(() => {
        this.$message.info('已取消操作')
      })
    }
  }
}
</script>

<style scoped>

</style>