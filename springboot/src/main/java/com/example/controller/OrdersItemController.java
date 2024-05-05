package com.example.controller;

import com.example.common.Result;
import com.example.entity.OrdersItem;
import com.example.service.OrdersItemService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import java.util.List;


@RestController
@RequestMapping("/ordersItem")
public class OrdersItemController {

    @Resource
    private OrdersItemService ordersItemService;


    @PostMapping("/add")
    public Result add(@RequestBody OrdersItem ordersItem) {
        ordersItemService.add(ordersItem);
        return Result.success();
    }


    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        ordersItemService.deleteById(id);
        return Result.success();
    }


    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        ordersItemService.deleteBatch(ids);
        return Result.success();
    }


    @PutMapping("/update")
    public Result updateById(@RequestBody OrdersItem ordersItem) {
        ordersItemService.updateById(ordersItem);
        return Result.success();
    }


    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        OrdersItem ordersItem = ordersItemService.selectById(id);
        return Result.success(ordersItem);
    }


    @GetMapping("/selectAll")
    public Result selectAll(OrdersItem ordersItem ) {
        List<OrdersItem> list = ordersItemService.selectAll(ordersItem);
        return Result.success(list);
    }


    @GetMapping("/selectPage")
    public Result selectPage(OrdersItem ordersItem,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<OrdersItem> page = ordersItemService.selectPage(ordersItem, pageNum, pageSize);
        return Result.success(page);
    }

}