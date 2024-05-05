package com.example.service;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.IdUtil;
import com.example.common.enums.OrderStatusEnum;
import com.example.common.enums.ResultCodeEnum;
import com.example.common.enums.RoleEnum;
import com.example.entity.*;
import com.example.exception.CustomException;
import com.example.mapper.OrdersMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * 业务处理
 **/
@Service
public class OrdersService {

    private static final Logger log = LoggerFactory.getLogger(OrdersService.class);

    @Resource
    private OrdersMapper ordersMapper;

    @Resource
    private CartService cartService;

    @Resource
    private OrdersItemService ordersItemService;



    /**
     * 新增
     */
    public void add(Orders orders) {
        ordersMapper.insert(orders);
    }

    /**
     * 删除
     */
    @Transactional
    public void deleteById(Integer id) {
        ordersMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            ordersMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(Orders orders) {
        //set Paytime
        //in .equals,put certain time first to prevent null
        if (OrderStatusEnum.NO_SEND.getValue().equals(orders.getStatus())) {
            orders.setPayTime(DateUtil.now());
        }
        ordersMapper.updateById(orders);
    }

    /**
     * 根据ID查询
     */
    public Orders selectById(Integer id) {
        return ordersMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Orders> selectAll(Orders orders) {
        // 拿到当前的登录用户信息
        Account currentUser = TokenUtils.getCurrentUser();
        String role = currentUser.getRole();
        if (RoleEnum.BUSINESS.name().equals(role)) {  // 如果是商家的话   只能查询自己的分类
            orders.setBusinessId(currentUser.getId());  // 设置商家自己的Id作为查询条件
        }
        return ordersMapper.selectAll(orders);
    }

    /**
     * 分页查询
     */
    public PageInfo<Orders> selectPage(Orders orders, Integer pageNum, Integer pageSize) {
        // 拿到当前的登录用户信息
        Account currentUser = TokenUtils.getCurrentUser();
        String role = currentUser.getRole();
        if (RoleEnum.BUSINESS.name().equals(role)) {  // 如果是商家的话   只能查询自己的分类
            orders.setBusinessId(currentUser.getId());  // 设置商家自己的Id作为查询条件
        }
        PageHelper.startPage(pageNum, pageSize);
        List<Orders> list = ordersMapper.selectAll(orders);
        return PageInfo.of(list);
    }
    // user make order in frontend
    @Transactional
    public void addOrder(OrdersDTO ordersDTO) {
        Integer businessId = ordersDTO.getBusinessId();
        Account currentUser = TokenUtils.getCurrentUser();
        Integer userId = currentUser.getId();
        if (userId == null) {
            throw new CustomException(ResultCodeEnum.NO_AUTH);
        }
        List<Cart> cartsList = cartService.selectUserCart(currentUser.getId(), businessId);
        if (CollUtil.isEmpty(cartsList)) {
            throw new CustomException(ResultCodeEnum.NO_GOODS);
        }
        Orders orders = new Orders();
        orders.setBusinessId(businessId);
        String now = DateUtil.now();
        orders.setTime(now);
        orders.setPayType(ordersDTO.getPayType());
        orders.setUserId(userId);
        orders.setAddress(ordersDTO.getAddress());
        orders.setUser(ordersDTO.getUser());
        orders.setPhone(ordersDTO.getPhone());
        orders.setComment(ordersDTO.getComment());

        // Goods info
        AmountDTO amountDTO = cartService.calc(userId, businessId);
        orders.setAmount(amountDTO.getAmount());
        orders.setDiscount(amountDTO.getDiscount());
        orders.setActual(amountDTO.getActual());

        // total goods numbers in cart
        Integer nums = cartsList.stream().map(Cart::getNum).reduce(Integer::sum).orElse(0);
        orders.setName(cartsList.get(0).getGoods().getName() + "等" + nums + "件商品");
        orders.setCover(cartsList.get(0).getGoods().getImg());

        //order no.
        orders.setOrderNo(IdUtil.getSnowflakeNextIdStr()); //Snowflake to generator id

        //orderStatus
        orders.setStatus(OrderStatusEnum.NO_PAY.getValue());
        this.add(orders);

        // Detail info of Order
        for (Cart cart : cartsList) {
            OrdersItem ordersItem = new OrdersItem();
            ordersItem.setOrderId(orders.getId());
            ordersItem.setGoodsName(cart.getGoods().getName());
            ordersItem.setGoodsImg(cart.getGoods().getImg());
            ordersItem.setPrice(cart.getGoods().getActualPrice());
            ordersItem.setNum(cart.getNum());
            ordersItemService.add(ordersItem);
        }


        cartService.deleteByBusiness(businessId, userId);
    }
}