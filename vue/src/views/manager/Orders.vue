<template>
  <div>
    <div class="search">
      <el-input placeholder="请输入订单编号查询" style="width: 200px" v-model="orderNo"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="load(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="reset">重置</el-button>
    </div>

    <div class="operation" v-if="user.role === 'ADMIN'">
      <el-button type="danger" plain @click="delBatch">批量删除</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" strip @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="序号" width="70" align="center" sortable></el-table-column>
        <el-table-column prop="orderNo" label="订单编号"></el-table-column>
        <el-table-column prop="name" label="订单名称"></el-table-column>
        <el-table-column prop="status" label="订单状态">
          <template v-slot="scope">
            <el-tag type="danger" v-if="scope.row.status === 'canceled'">已取消</el-tag>
            <el-tag type="warning" v-if="scope.row.status === 'awaitpayment'">待支付</el-tag>
            <el-tag type="primary" v-if="scope.row.status === 'awaitshipping'">待发货</el-tag>
            <el-tag type="primary" v-if="scope.row.status === 'awaitreceiption'">待收货</el-tag>
            <el-tag type="info" v-if="scope.row.status === 'awaitcomments'">待评价</el-tag>
            <el-tag type="success" v-if="scope.row.status === 'complete'">已完成</el-tag>
            <el-tag type="red" v-if="scope.row.status === 'refunded'">已退款</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="businessName" label="接单商家"></el-table-column>
        <el-table-column prop="address" label="送货地址"></el-table-column>
        <el-table-column prop="phone" label="下单人电话"></el-table-column>
        <el-table-column prop="userName" label="下单人"></el-table-column>
        <el-table-column prop="amount" label="订单总价"></el-table-column>
        <el-table-column prop="discount" label="优惠金额"></el-table-column>
        <el-table-column prop="actual" label="实付款"></el-table-column>
        <el-table-column prop="comment" label="备注"></el-table-column>
        <el-table-column prop="time" label="下单时间"></el-table-column>
        <el-table-column prop="payTime" label="支付时间"></el-table-column>
        <el-table-column prop="payType" label="支付类型"></el-table-column>
              <el-table-column label="详情" align="center" width="90" fixed="right">
                <template v-slot="scope">
                  <el-button size="mini" type="primary" plain @click="loadDetail(scope.row.id)">查看详情</el-button>
                </template>
              </el-table-column>
        <el-table-column label="操作" align="center" width="240" fixed="right">
          <template v-slot="scope">
            <el-button size="mini" type="info" @click="sendGoods(scope.row)" v-if="scope.row.status === 'awaitshipping'">发货</el-button>
            <el-button size="mini" type="primary" plain @click="handleEdit(scope.row)"  v-if="user.role === 'ADMIN'">编辑</el-button>
            <el-button size="mini" type="danger" plain @click="del(scope.row.id)" v-if="user.role === 'ADMIN'">删除</el-button>
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


    <el-dialog title="订单管理" :visible.sync="fromVisible" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-form :model="form" label-width="100px" style="padding-right: 50px" :rules="rules" ref="formRef">
        <el-form-item label="订单编号" prop="orderNo">
          <el-input v-model="form.orderNo" placeholder="订单编号" disabled></el-input>
        </el-form-item>
        <el-form-item label="订单名称" prop="name">
          <el-input v-model="form.name" placeholder="订单名称"></el-input>
        </el-form-item>
        <el-form-item label="订单状态" prop="status">
          <el-select style="width: 100%" v-model="form.status">
            <el-option v-for="(label, value) in orderStatusMap" :key="value" :value="value" :label="label"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="下单时间" prop="time">
          <el-date-picker disabled format="yyyy-MM-dd HH:mm:ss" value-format="yyyy-MM-dd HH:mm:ss"
                          v-model="form.time" style="width: 100%" ></el-date-picker>
        </el-form-item>
        <el-form-item label="支付时间" prop="payTime">
          <el-date-picker disabled format="yyyy-MM-dd HH:mm:ss" value-format="yyyy-MM-dd HH:mm:ss"
                          v-model="form.payTime" style="width: 100%"></el-date-picker>
        </el-form-item>
        <el-form-item label="支付类型" prop="payType">
          <el-input v-model="form.payType" placeholder="支付类型" disabled></el-input>
        </el-form-item>
        <el-form-item label="接单商家" prop="managerId">
          <el-select disabled style="width: 100%" v-model="form.businessId">
            <el-option v-for="item in businessList" :key="item.id" :value="item.id" :label="item.name"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="送货地址" prop="address">
          <el-input v-model="form.address" placeholder="送货地址"></el-input>
        </el-form-item>
        <el-form-item label="下单人电话" prop="phone">
          <el-input v-model="form.phone" placeholder="下单人电话"></el-input>
        </el-form-item>
        <el-form-item label="下单人" prop="userId">
          <el-select style="width: 100%" v-model="form.userId">
            <el-option v-for="item in userList" :key="item.id" :value="item.id" :label="item.name"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="订单总价" prop="amount">
          <el-input v-model="form.amount" placeholder="订单总价"></el-input>
        </el-form-item>
        <el-form-item label="优惠金额" prop="discount">
          <el-input v-model="form.discount" placeholder="优惠金额"></el-input>
        </el-form-item>
        <el-form-item label="实付款" prop="actual">
          <el-input v-model="form.actual" placeholder="实付款"></el-input>
        </el-form-item>
        <el-form-item label="备注" prop="comment">
          <el-input v-model="form.comment" placeholder="备注"></el-input>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button @click="fromVisible = false">取 消</el-button>
        <el-button type="primary" @click="save">确 定</el-button>
      </div>
    </el-dialog>

    <el-dialog title="订单详情信息" :visible.sync="fromVisible1" width="40%" :close-on-click-modal="false" destroy-on-close>
      <el-table :data="ordersItemList" strip @selection-change="handleSelectionChange">
        <el-table-column prop="orderId" label="订单ID" align="center"></el-table-column>
        <el-table-column prop="goodsName" label="商品名称"></el-table-column>
        <el-table-column prop="goodsImg" label="商品图片">
          <template v-slot="scope">
            <div style="display: flex; align-items: center">
              <el-image style="width: 40px; height: 40px;" v-if="scope.row.goodsImg"
                        :src="scope.row.goodsImg" :preview-src-list="[scope.row.goodsImg]"></el-image>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="price" label="商品价格" align="center"></el-table-column>
        <el-table-column prop="num" label="购买数量" align="center"></el-table-column>
      </el-table>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="fromVisible1 = false">确 定</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: "Orders",
  data() {
    return {
      tableData: [],
      businessList: [], // declare business info
      userList: [],
      ordersItemList: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      orderNo: null,
      fromVisible: false,
      fromVisible1: false,
      form: {},
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      orderStatusMap: {
        'awaitpayment': '待支付',
        'awaitshipping': '待发货',
        'awaitreceiption': '待收货',
        'awaitcomments': '待评价',
        'refunded': '已退款',
        'complete': '已完成',
        'canceled': '已取消'
      },
      rules: {
        name: [
          {required: true, message: '请输入名称', trigger: 'blur'},
        ],
      },
      ids: []
    }
  },
  created() {
    this.load(1)

    this.$request.get('/user/selectAll?role=CUSTOMER').then(res => {
      this.userList = res.data
    })

    this.$request.get('/user/selectAll?role=BUSINESS').then(res => {
      this.businessList = res.data
    })
  },
  methods: {
    sendGoods(row) {
      let form = JSON.parse(JSON.stringify(row)) // deep copy not change data in the website in time
      form.status = 'awaitreceiption'
      this.$request.put('/orders/update' , form).then(res => {
        if (res.code === '200') {
          this.$message.success('保存成功')
          this.load(1)
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    loadDetail(orderId) {
      this.$request.get('/ordersItem/selectAll', {
        params: {
          orderId: orderId
        }
      }).then(res => {
        this.ordersItemList = res.data
        this.fromVisible1 = true  // open windows
      })
    },
    handleAdd() {
      this.form = {}
      this.fromVisible = true
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row))
      this.fromVisible = true
    },
    save() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          this.$request({
            url: this.form.id ? '/orders/update' : '/orders/add',
            method: this.form.id ? 'PUT' : 'POST',
            data: this.form
          }).then(res => {
            if (res.code === '200') {
              this.$message.success('保存成功')
              this.load(1)
              this.fromVisible = false
            } else {
              this.$message.error(res.msg)
            }
          })
        }
      })
    },
    del(id) {
      this.$confirm('您确定删除吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/orders/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)
          }
        })
      }).catch(() => {
      })
    },
    handleSelectionChange(rows) {
      this.ids = rows.map(v => v.id)
    },
    delBatch() {
      if (!this.ids.length) {
        this.$message.warning('请选择数据')
        return
      }
      this.$confirm('您确定批量删除这些数据吗？', '确认删除', {type: "warning"}).then(response => {
        this.$request.delete('/orders/delete/batch', {data: this.ids}).then(res => {
          if (res.code === '200') {
            this.$message.success('操作成功')
            this.load(1)
          } else {
            this.$message.error(res.msg)
          }
        })
      }).catch(() => {
      })
    },
    load(pageNum) {  // 分页查询
      if (pageNum) this.pageNum = pageNum
      this.$request.get('/orders/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          orderNo: this.orderNo,
        }
      }).then(res => {
        this.tableData = res.data?.list
        this.total = res.data?.total
      })
    },
    reset() {
      this.orderNo = null
      this.load(1)
    },
    handleCurrentChange(pageNum) {
      this.load(pageNum)
    },
  }
}
</script>

<style scoped>

</style>