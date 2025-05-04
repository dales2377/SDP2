<template>
  <div>
    <div class="card" style="padding: 15px">
      您好，{{ user?.name }}！欢迎使用本系统
    </div>

    <div style="display: flex; margin: 10px 0; gap: 20px">
      <!-- 左侧公告列表 -->
      <div style="width: 50%;" class="card">
        <div style="margin-bottom: 30px; font-size: 20px; font-weight: bold">公告列表</div>
        <div>
          <el-timeline reverse slot="reference">
            <el-timeline-item v-for="item in notices" :key="item.id" :timestamp="item.time">
              <el-popover placement="right" width="200" trigger="hover" :content="item.content">
                <span slot="reference">{{ item.title }}</span>
              </el-popover>
            </el-timeline-item>
          </el-timeline>
        </div>
      </div>

      <!-- 右侧统计和图表 -->
      <div style="width: 50%;">
        <!-- 日期选择 -->
        <div class="card" style="padding: 20px; margin-bottom: 20px">
          <div style="display: flex; align-items: center; gap: 10px">
            <span style="font-size: 16px; color: #666">统计时间：</span>
            <el-date-picker
              v-model="dateRange"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              value-format="yyyy-MM-dd HH:mm:ss"
              :default-time="['00:00:00', '23:59:59']"
              @change="handleDateChange">
            </el-date-picker>
          </div>
        </div>

        <!-- 统计卡片 -->
        <div style="display: flex; gap: 20px; margin-bottom: 20px">
          <div class="card" style="flex: 1; padding: 20px">
            <div style="font-size: 16px; color: #666; margin-bottom: 10px">订单总数</div>
            <div style="font-size: 24px; font-weight: bold; color: #409EFF">{{ orderNum }}</div>
          </div>
          <div class="card" style="flex: 1; padding: 20px">
            <div style="font-size: 16px; color: #666; margin-bottom: 10px">收入总数</div>
            <div style="font-size: 24px; font-weight: bold; color: #67C23A">¥{{ income }}</div>
          </div>
        </div>

        <!-- 热门产品图表 -->
        <div class="card" style="padding: 20px">
          <div style="font-size: 20px; font-weight: bold; margin-bottom: 20px">热门产品统计</div>
          <div ref="hotGoodsChart" style="width: 100%; height: 300px"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts'

export default {
  name: 'Home',
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      notices: [],
      orderNum: 0,
      income: 0,
      hotGoodsChart: null,
      dateRange: [], // 日期范围
    }
  },
  created() {
    // 设置默认日期范围为当前月
    const now = new Date()
    const endDay = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59)
    const startDay = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate(), 0, 0, 0)
    this.dateRange = [
      this.formatDate(startDay),
      this.formatDate(endDay)
    ]
    
    this.loadNotices()
    this.loadOrderNum()
    this.loadIncome()
    this.loadHotGoods()
  },
  mounted() {
    // 初始化图表
    this.initChart()
    // 监听窗口大小变化，重绘图表
    window.addEventListener('resize', this.resizeChart)
  },
  beforeDestroy() {
    // 组件销毁前移除事件监听
    window.removeEventListener('resize', this.resizeChart)
    // 销毁图表实例
    if (this.hotGoodsChart) {
      this.hotGoodsChart.dispose()
    }
  },
  methods: {
    // 格式化日期
    formatDate(date) {
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      const hours = String(date.getHours()).padStart(2, '0')
      const minutes = String(date.getMinutes()).padStart(2, '0')
      const seconds = String(date.getSeconds()).padStart(2, '0')
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
    },

    // 处理日期变化
    handleDateChange() {
      this.loadOrderNum()
      this.loadIncome()
    },

    // 加载公告列表
    loadNotices() {
      this.$request.get('/notice/selectAll').then(res => {
        this.notices = res.data || []
      })
    },
    // 加载订单总数
    loadOrderNum() {
      if (!this.dateRange || this.dateRange.length !== 2) return
      this.$request.post('/report/generateOrderNum', {
        startTime: this.dateRange[0],
        endTime: this.dateRange[1]
      }).then(res => {
        if (res.code === '200') {
          this.orderNum = res.data || 0
        }
      })
    },
    // 加载收入总数
    loadIncome() {
      if (!this.dateRange || this.dateRange.length !== 2) return
      this.$request.post('/report/income', {
        startTime: this.dateRange[0],
        endTime: this.dateRange[1]
      }).then(res => {
        if (res.code === '200') {
          this.income = res.data || 0
        }
      })
    },
    // 加载热门产品数据
    loadHotGoods() {
      this.$request.post('/report/hotGoods', {}).then(res => {
        if (res.code === '200') {
          this.updateChart(res.data || [])
        }
      })
    },
    // 初始化图表
    initChart() {
      this.hotGoodsChart = echarts.init(this.$refs.hotGoodsChart)
      this.updateChart([])
    },
    // 更新图表数据
    updateChart(data) {
      const option = {
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          right: 10,
          top: 'center'
        },
        series: [
          {
            name: '热门产品',
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            itemStyle: {
              borderRadius: 10,
              borderColor: '#fff',
              borderWidth: 2
            },
            label: {
              show: false,
              position: 'center'
            },
            emphasis: {
              label: {
                show: true,
                fontSize: '18',
                fontWeight: 'bold'
              }
            },
            labelLine: {
              show: false
            },
            data: data.map(item => ({
              name: item.goodsName,
              value: item.nums
            }))
          }
        ]
      }
      this.hotGoodsChart.setOption(option)
    },
    // 重绘图表
    resizeChart() {
      if (this.hotGoodsChart) {
        this.hotGoodsChart.resize()
      }
    }
  }
}
</script>

<style scoped>
.card {
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
</style>
