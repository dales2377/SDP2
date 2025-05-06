package com.example.service;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import com.example.common.enums.ResultCodeEnum;
import com.example.common.enums.RoleEnum;
import com.example.entity.*;
import com.example.exception.CustomException;
import com.example.mapper.UserMapper;
import com.example.utils.BCryptUtils;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;
import java.util.Objects;

/**
 * 用户表业务处理
 **/
@Service
public class UserService {

    private static final String sign = "abcdefghijklmnapqrstuvwxyz";

    @Resource
    private UserMapper userMapper;
    @Resource
    private CollectService collectService;

    @Resource
    private CommentService commentService;

    @Resource
    private OrdersService ordersService;

    @Resource
    private OrdersItemService ordersItemService;

    /**
     * 新增
     */
    public void add(User user) {
        User dbUser = userMapper.selectByUsername(user.getUsername());
        if (ObjectUtil.isNotNull(dbUser)) {
            throw new CustomException(ResultCodeEnum.USER_EXIST_ERROR);
        }
        if (ObjectUtil.isEmpty(user.getName())) {
            user.setName(user.getUsername());
        }
        //密码加密
        String newPwd = BCryptUtils.hashPassword(user.getPassword());
        user.setPassword(newPwd);
//        user.setRole(RoleEnum.USER.name());
        userMapper.insert(user);
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        userMapper.deleteById(id);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            userMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    public void updateById(User user) {
        User dbUser2 = userMapper.selectByUsername(user.getUsername());
        //  根据当前更新的用户的账号查询数据库  如果数据库存在跟当前更新用户一样账号的数据  那么当前的更新是不合法的  数据重复了
        if (ObjectUtil.isNotEmpty(dbUser2) && !Objects.equals(dbUser2.getId(), user.getId())) {
            throw new CustomException(ResultCodeEnum.USER_EXIST_ERROR);
        }
        userMapper.updateById(user);
    }

    /**
     * 根据ID查询
     */
    public User selectById(Integer id) {
        return userMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<User> selectAll(User user) {
//        if (user.getRole().equals("BUSINESS")) {
//            user.setStatus("通过");
//        }
        List<User> users = userMapper.selectAll(user);
        for (User b : users) {
            if (b.getRole().equals(RoleEnum.BUSINESS.name())){
                wrapBusiness(b);
            }

        }
        return users;
    }
    private void wrapBusiness(User b) {
        List<Comment> commentList = commentService.selectByBusinessId(b.getId());
        double sum = commentList.stream().map(Comment::getStar).reduce(Double::sum).orElse(0D) + 5D;
        // 5 + 4.5 / 1 + 1
        double score = BigDecimal.valueOf(sum).divide(BigDecimal.valueOf(commentList.size() + 1), 1, BigDecimal.ROUND_UP).doubleValue();
        b.setScore(score);

        // 查出所有有效的订单
        List<Orders> ordersList = ordersService.selectUsageByBusinessId(b.getId());
        int nums = 0;
        for (Orders orders : ordersList) {
            List<OrdersItem> ordersItemList = ordersItemService.selectByOrderId(orders.getId());
            // 聚合函数查出订单的商品数量
            nums += ordersItemList.stream().map(OrdersItem::getNum).reduce(Integer::sum).orElse(0);
        }
        b.setNums(nums);
    }

    /**
     * 分页查询
     */
    public PageInfo<User> selectPage(User user, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<User> list = userMapper.selectAll(user);
        return PageInfo.of(list);
    }

    /**
     * login
     */
    public Account login(Account account) {
        User dbUser = this.selectByUsername(account.getUsername());
        if (dbUser.getIsActive()==0) {
            throw new CustomException(ResultCodeEnum.forbidden);
        }
        if (ObjectUtil.isNull(dbUser)) {
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }

        if (!BCryptUtils.checkPassword(account.getPassword(), dbUser.getPassword())) {   // compare password is same or not
            throw new CustomException(ResultCodeEnum.USER_ACCOUNT_ERROR);
        }
        // generate token
        String tokenData = dbUser.getId() + "-" + dbUser.getRole();
        String token = TokenUtils.createToken(tokenData, sign);
        dbUser.setToken(token);
        return dbUser;
    }

    private User selectByUsername(String username) {
        User user = new User();
        user.setUsername(username);
        List<User> userList = this.selectAll(user);
        return CollUtil.isEmpty(userList) ? null : userList.get(0);
    }

    /**
     * 用户注册
     */
    public void register(Account account) {
        User user = new User();
        BeanUtils.copyProperties(account, user);  // 拷贝 账号和密码2个属性
        this.add(user);  // 添加账户信息
    }

    /**
     * 重置密码
     * @param user
     */
    public void resetPassword(User user) {
        userMapper.resetPassword(user);
    }

    /**
     * 修改密码
     * @param account
     */
    public void updatePassword(Account account) {
        User user = this.selectByUsername(account.getUsername());
        if (ObjectUtil.isNull(user)) {
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        if (!BCryptUtils.checkPassword(account.getPassword(), user.getPassword())) {
            throw new CustomException(ResultCodeEnum.PARAM_PASSWORD_ERROR);
        }
        user.setPassword(BCryptUtils.hashPassword(account.getNewPassword()));
        this.updateById(user);
    }
}