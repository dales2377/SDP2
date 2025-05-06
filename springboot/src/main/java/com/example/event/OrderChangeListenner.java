package com.example.event;

import com.example.entity.OrderNotice;
import com.example.entity.Orders;
import com.example.service.OrderNoticeService;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

@Component
public class OrderChangeListenner implements ApplicationListener<OrderChangeEvent> {
    @Resource
    private OrderNoticeService orderNoticeService;
    @Override
    public void onApplicationEvent(OrderChangeEvent event) {
        //进行保存通知表
        Orders source = (Orders)event.getSource();
        OrderNotice orderNotice = new OrderNotice();
        orderNotice.setOrderId(source.getId());
        orderNoticeService.add(orderNotice);
    }
}
