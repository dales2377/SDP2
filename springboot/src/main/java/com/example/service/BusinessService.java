package com.example.service;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.crypto.digest.BCrypt;
import com.example.common.enums.ResultCodeEnum;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.Admin;
import com.example.entity.Business;
import com.example.exception.CustomException;
import com.example.mapper.BusinessMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Objects;

// Business method
@Service
public class BusinessService {

    @Resource
    private BusinessMapper businessMapper;
    /**
     *  add
     */
    public void add(Business business) {
        Business dbBusiness = this.selectByUsername(business.getUsername());
        // No duplicate
        if (ObjectUtil.isNotEmpty(dbBusiness)) {
            throw new CustomException(ResultCodeEnum.USER_EXIST_ERROR);
        }
        business.setRole(RoleEnum.BUSINESS.name());
        String hash = BCrypt.hashpw(business.getPassword());
        business.setPassword(hash);
        System.out.println(hash);
        System.out.println(business.getPassword());
        businessMapper.insert(business);
    }

    /**
     *  delete
     */
    public void deleteById(Integer id) {
        businessMapper.deleteById(id);
    }

    /**
     * batch delete
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            this.deleteById(id);
        }
    }

    /**
     * update
     */
    public void updateById(Business business) {
        // check data exist first
        Business dbBusiness1 = selectById(business.getId());
        if (ObjectUtil.isEmpty(dbBusiness1)) {
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        Business dbBusiness2 = this.selectByUsername(business.getUsername());
        //  prevent duplicate
        if (ObjectUtil.isNotEmpty(dbBusiness2) && !Objects.equals(dbBusiness2.getId(), business.getId())) {
            throw new CustomException(ResultCodeEnum.USER_EXIST_ERROR);
        }
        businessMapper.updateById(business);
    }


    public List<Business> selectAll(Business business) {
        return businessMapper.selectAll(business);
}

    /**
     * search by account
     */
    public Business selectByUsername(String username) {
        Business params = new Business();
        params.setUsername(username);
        List<Business> list = this.selectAll(params);
        return list.size() == 0 ? null : list.get(0);
    }

    /**
     * search by id
     */
    public Business selectById(Integer id) {
        Business params = new Business();
        params.setId(id);
        List<Business> list = this.selectAll(params);
        return list.size() == 0 ? null : list.get(0);
    }

    /**
     * pagehelper
     */
    public PageInfo<Business> selectPage(Business business, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Business> list = businessMapper.selectAll(business);
        return PageInfo.of(list);
    }

    /**
     * register
     */
    public void register(Account account) {
        Business business = new Business();
        BeanUtils.copyProperties(account, business);  //  copy password and user from account parent class
       if (ObjectUtil.isEmpty(account.getName())) {
           business.setName(business.getUsername());
        }
        this.add(business);  // add account info into database
    }

    /**
     * login
     */
    public Account login(Account account) {
        Business dbBusiness = this.selectByUsername(account.getUsername());
        if (ObjectUtil.isNull(dbBusiness)) {
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        if (!account.getPassword().equals(dbBusiness.getPassword())) {   // compare password is same or not
            throw new CustomException(ResultCodeEnum.USER_ACCOUNT_ERROR);
        }
        // generate token
        String tokenData = dbBusiness.getId() + "-" + RoleEnum.BUSINESS.name();
        String token = TokenUtils.createToken(tokenData, dbBusiness.getPassword());
        dbBusiness.setToken(token);
        return dbBusiness;
    }

    /**
     * update password
     */
    public void updatePassword(Account account) {
        Business dbBusiness = this.selectByUsername(account.getUsername());
        if (ObjectUtil.isNull(dbBusiness)) {
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        if (!account.getPassword().equals(dbBusiness.getPassword())) {
            throw new CustomException(ResultCodeEnum.PARAM_PASSWORD_ERROR);
        }
        dbBusiness.setPassword(account.getNewPassword());
        this.updateById(dbBusiness);
    }

    /**
     * auth check
     */
    public void checkBusinessAuth() {
        Account currentUser = TokenUtils.getCurrentUser();  // get current token
        if (RoleEnum.BUSINESS.name().equals(currentUser.getRole())) {   //if is business
            Business business = selectById(currentUser.getId());
            if (!"通过".equals(business.getStatus())) {   // only auth business allow to do that
                throw new CustomException(ResultCodeEnum.NO_AUTH);
            }
        }
    }
}
