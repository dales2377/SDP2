package com.example.mapper;

import com.example.entity.CountVO;
import com.example.entity.Orders;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 操作orders相关数据接口
 */
public interface OrdersMapper {

    /**
     * 新增
     */
    int insert(Orders orders);

    /**
     * 删除
     */
    int deleteById(Integer id);

    /**
     * 修改
     */
    int updateById(Orders orders);

    /**
     * 根据ID查询
     */
    Orders selectById(Integer id);

    /**
     * 查询所有
     */
    List<Orders> selectAll(Orders orders);

    @Select("select * from orders where business_id = #{businessId} and (status = 'awaitcomments' or status = 'complete')")
    List<Orders> selectUsageByBusinessId(Integer businessId);

    Integer generateOrderNum(CountVO param, Integer id);

    Double income(CountVO param);
}