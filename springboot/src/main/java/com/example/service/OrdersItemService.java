package com.example.service;

import com.example.entity.Account;
import com.example.entity.CountVO;
import com.example.entity.GoodsOrderVO;
import com.example.entity.OrdersItem;
import com.example.mapper.OrdersItemMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;

/**
 * 订单详情表业务处理
 **/
@Service
public class OrdersItemService {
    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Resource
    private OrdersItemMapper ordersItemMapper;

    @Resource
    private GoodsService goodsService;

    /**
     * 新增
     */
    public void add(OrdersItem ordersItem) {
        ordersItemMapper.insert(ordersItem);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        ordersItemMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            ordersItemMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(OrdersItem ordersItem) {
        ordersItemMapper.updateById(ordersItem);
    }

    /**
     * 根据ID查询
     */
    public OrdersItem selectById(Integer id) {
        return ordersItemMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<OrdersItem> selectAll(OrdersItem ordersItem) {
        return ordersItemMapper.selectAll(ordersItem);
    }

    /**
     * 分页查询
     */
    public PageInfo<OrdersItem> selectPage(OrdersItem ordersItem, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<OrdersItem> list = ordersItemMapper.selectAll(ordersItem);
        return PageInfo.of(list);
    }

    public void deleteByOrderId(Integer orderId) {
        ordersItemMapper.deleteByOrderId(orderId);
    }

    public List<OrdersItem> selectByOrderId(Integer ordersId) {
        OrdersItem ordersItem = new OrdersItem();
        ordersItem.setOrderId(ordersId);
        return ordersItemMapper.selectAll(ordersItem);
    }

    public List<OrdersItem> selectByGoodsId(Integer goodsId) {
        OrdersItem ordersItem = new OrdersItem();
        ordersItem.setGoodsId(goodsId);
        return ordersItemMapper.selectAll(ordersItem);
    }

    public List<GoodsOrderVO> hotGoods(CountVO req) {
        Account currentUser = TokenUtils.getCurrentUser();

        if (req.getStartTime()==null||req.getEndTime()==null) {
            req.setStartTime(getCurStartTime());
            req.setEndTime(getCurEndTime());
        }
        if (currentUser.getRole().equals("ADMIN")) {
            req.setBussinessId(null);
        }else {
            req.setBussinessId(currentUser.getId());
        }
        List<GoodsOrderVO> result = ordersItemMapper.hotGoods(req);
        result.sort(Comparator.comparing(GoodsOrderVO::getNums).reversed());
        return result;
    }
    private String getCurEndTime() {

        LocalDate today = LocalDate.now();

        // 当天凌晨时间 (00:00:00)
        String startOfDay = today.atStartOfDay().format(FORMATTER);
        return startOfDay;
    }

    private String getCurStartTime() {
        LocalDate today = LocalDate.now();
        // 当天最后时间 (23:59:59)
        String endOfDay = LocalDateTime.of(today, LocalTime.of(23, 59, 59))
                .format(FORMATTER);
        return endOfDay;
    }
}