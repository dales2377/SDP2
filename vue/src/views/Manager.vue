<template>
  <div class="manager-container">
    <!--  头部  -->
    <div class="manager-header">
      <div class="manager-header-left">
        <img src="@/assets/imgs/logo.png" />
        <div class="title">后台管理系统</div>
      </div>

      <div class="manager-header-center">
        <el-breadcrumb separator-class="el-icon-arrow-right">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: $route.path }">{{ $route.meta.name }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>

      <div class="manager-header-right">
        <!-- 通知图标 -->
        <el-badge :value="notifications.length" :hidden="notifications.length === 0" class="notice-badge">
          <el-popover
            placement="bottom"
            width="400"
            trigger="click"
            v-model="showNotifications">
            <div class="notification-list">
              <div class="notification-header">
                <span>订单通知</span>
                <el-button type="text" @click="clearAllNotifications" v-if="notifications.length > 0">清空</el-button>
              </div>
              <div v-if="notifications.length === 0" class="empty-notice">
                暂无通知
              </div>
              <div v-else class="notification-items">
                <div v-for="item in notifications" :key="item.id" class="notification-item">
                  <div class="notification-content">
                    <div class="notification-title">
                      <span>订单号：{{ item.orderNo }}</span>
                      <el-button type="text" size="mini" @click="deleteNotification(item.noticeId)">删除</el-button>
                    </div>
                    <div class="notification-info">
                      <div>商品：{{ item.name }}</div>
                      <div>金额：¥{{ item.actual }}</div>
                      <div>状态：{{ orderStatusMap[item.status] || item.status }}</div>
                      <div>时间：{{ item.time }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <el-button slot="reference" type="text" class="notice-button">
              <i class="el-icon-bell" style="font-size: 20px"></i>
            </el-button>
          </el-popover>
        </el-badge>

        <el-dropdown placement="bottom">
          <div class="avatar">
            <img :src="user.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'" />
            <div>{{ user.name ||  '' }}</div>
          </div>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item @click.native="goToPerson">个人信息</el-dropdown-item>
            <el-dropdown-item @click.native="$router.push('/password')">修改密码</el-dropdown-item>
            <el-dropdown-item @click.native="logout">退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
    </div>

    <!--  主体  -->
    <div class="manager-main">
      <!--  侧边栏  -->
      <div class="manager-main-left">
        <el-menu :default-openeds="['info', 'user']" router style="border: none" :default-active="$route.path">
          <el-menu-item index="/home">
            <i class="el-icon-s-home"></i>
            <span slot="title">系统首页</span>
          </el-menu-item>
          <el-submenu index="info">
            <template slot="title">
              <i class="el-icon-menu"></i><span>信息管理</span>
            </template>
            <el-menu-item index="/category">商品分类信息</el-menu-item>
            <el-menu-item index="/goods">商品信息</el-menu-item>
            <el-menu-item index="/orders">订单管理信息</el-menu-item>
            <el-menu-item index="/banner" v-if="user.role === 'ADMIN'" >广告信息</el-menu-item>
            <!--权限修改-->
            <el-menu-item index="/notice" v-if="user.role === 'ADMIN'" >公告信息</el-menu-item>
            <el-menu-item index="/collect">店铺收藏信息</el-menu-item>
            <el-menu-item index="/comment">店铺评论信息</el-menu-item>

          </el-submenu>

          <el-submenu index="user" v-if="user.role === 'ADMIN'">
            <template slot="title">
              <i class="el-icon-menu"></i><span>角色管理</span>
            </template>
            <el-menu-item index="/admin">管理员信息</el-menu-item>
            <el-menu-item index="/business">商家信息</el-menu-item>
            <el-menu-item index="/user">用户管理</el-menu-item>

          </el-submenu>
        </el-menu>
      </div>

      <!--  数据表格  -->
      <div class="manager-main-right">
        <router-view @update:user="updateUser" />
      </div>
    </div>

  </div>
</template>

<script>
export default {
  name: "Manager",
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      notifications: [], // 通知列表
      showNotifications: false, // 控制通知列表显示
      notificationTimer: null, // 轮询定时器
      // 添加订单状态映射
      orderStatusMap: {
        'awaitpayment': '待支付',
        'awaitshipping': '待发货',
        'awaitreceiption': '待收货',
        'awaitcomments': '待评价',
        'refunded': '已退款',
        'complete': '已完成',
        'canceled': '已取消'
      }
    }
  },
  created() {
    if (!this.user.id) {
      this.$router.push('/login')
    }
    this.loadNotifications() // 加载通知
    // 启动轮询，每30秒检查一次新通知
    this.startNotificationPolling()
  },
  beforeDestroy() {
    // 组件销毁前清除定时器
    this.stopNotificationPolling()
  },
  methods: {
    updateUser() {
      this.user = JSON.parse(localStorage.getItem('xm-user') || '{}')   // 重新获取下用户的最新信息
    },
    goToPerson() {
      if (this.user.role === 'ADMIN') {
        this.$router.push('/adminPerson')
      } else if (this.user.role === 'BUSINESS') {
        this.$router.push('/businessPerson')
      }
    },
    logout() {
      localStorage.removeItem('xm-user')
      this.$router.push('/login')
    },
    // 启动通知轮询
    startNotificationPolling() {
      // 清除可能存在的旧定时器
      this.stopNotificationPolling()
      // 设置新的定时器，每30秒执行一次
      this.notificationTimer = setInterval(() => {
        this.loadNotifications()
      }, 30000) // 30秒
    },

    // 停止通知轮询
    stopNotificationPolling() {
      if (this.notificationTimer) {
        clearInterval(this.notificationTimer)
        this.notificationTimer = null
      }
    },

    // 加载通知列表
    loadNotifications() {
      this.$request.get('/orderNotic/getAll').then(res => {
        if (res.code === '200') {
          const oldLength = this.notifications.length
          this.notifications = res.data || []
          // 如果有新通知，显示提示
          if (this.notifications.length > oldLength) {
            this.$notify({
              title: '新订单通知',
              message: `您有${this.notifications.length - oldLength}条新订单通知`,
              type: 'info',
              duration: 3000
            })
          }
        }
      })
    },
    // 删除通知
    deleteNotification(id) {
      this.$confirm('确认删除该通知吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$request.post('/orderNotic/logicDel', { id }).then(res => {
          if (res.code === '200') {
            this.$message.success('删除成功')
            this.loadNotifications() // 重新加载通知列表
          }
        })
      }).catch(() => {})
    },
    // 清空所有通知
    clearAllNotifications() {
      this.$confirm('确认清空所有通知吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 逐个删除通知
        const deletePromises = this.notifications.map(item => 
          this.$request.post('/orderNotic/logicDel', { id: item.noticeId })
        )
        Promise.all(deletePromises).then(() => {
          this.$message.success('清空成功')
          this.loadNotifications() // 重新加载通知列表
        })
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
@import "@/assets/css/manager.css";

.notice-badge {
  margin-right: 20px;
}

.notice-button {
  padding: 0;
  margin: 0;
}

.notification-list {
  max-height: 400px;
  overflow-y: auto;
}

.notification-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #eee;
  margin-bottom: 10px;
}

.notification-items {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.notification-item {
  padding: 10px;
  border-bottom: 1px solid #f0f0f0;
}

.notification-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 5px;
}

.notification-info {
  font-size: 13px;
  color: #666;
  line-height: 1.5;
}

.empty-notice {
  text-align: center;
  color: #999;
  padding: 20px 0;
}
</style>