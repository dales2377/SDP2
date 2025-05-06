package com.example.controller;

import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.example.common.Result;
import com.example.common.enums.ResultCodeEnum;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.QuestionDTO;
import com.example.entity.UpdatePwdDTO;
import com.example.entity.User;
import com.example.service.AdminService;
import com.example.service.BusinessService;
import com.example.service.UserService;
import com.example.utils.BCryptUtils;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 基础前端接口
 */
@RestController
public class WebController {

    @Resource
    private AdminService adminService;

    @Resource
    private BusinessService businessService;

    @Resource
    private UserService userService;

    @GetMapping("/")
    public Result hello() {
        return Result.success("访问成功");
    }

    /**
     * 登录
     */
    @PostMapping("/login")
    public Result login(@RequestBody Account account) {
        if (ObjectUtil.isEmpty(account.getUsername()) || ObjectUtil.isEmpty(account.getPassword())
                || ObjectUtil.isEmpty(account.getRole())) {
            return Result.error(ResultCodeEnum.PARAM_LOST_ERROR);
        }
//        if (RoleEnum.ADMIN.name().equals(account.getRole())) {
//            account = adminService.login(account);
//        } else if (RoleEnum.BUSINESS.name().equals(account.getRole())) {
//            account = businessService.login(account);
//        } else if (RoleEnum.USER.name().equals(account.getRole())) {
//            account = userService.login(account);
//        }
        account = userService.login(account);
        return Result.success(account);
    }

    /**
     * 注册
     */
    @PostMapping("/register")
    public Result register(@RequestBody Account account) {
        if (StrUtil.isBlank(account.getUsername()) || StrUtil.isBlank(account.getPassword())
                || ObjectUtil.isEmpty(account.getRole())) {
            return Result.error(ResultCodeEnum.PARAM_LOST_ERROR);
        }
//        if (RoleEnum.ADMIN.name().equals(account.getRole())) {
//            adminService.register(account);
//        }
//        if (RoleEnum.BUSINESS.name().equals(account.getRole())) {
//            businessService.register(account);
//        } else  if (RoleEnum.USER.name().equals(account.getRole())) {
//            userService.register(account);
//        }
        userService.register(account);
        return Result.success();
    }

    /**
     * 修改密码
     */
    @PutMapping("/updatePassword")
    public Result updatePassword(@RequestBody Account account) {
        if (StrUtil.isBlank(account.getUsername()) || StrUtil.isBlank(account.getPassword())
                || ObjectUtil.isEmpty(account.getNewPassword())) {
            return Result.error(ResultCodeEnum.PARAM_LOST_ERROR);
        }
//        if (RoleEnum.ADMIN.name().equals(account.getRole())) {
//            adminService.updatePassword(account);
//        } else if (RoleEnum.BUSINESS.name().equals(account.getRole())) {
//            businessService.updatePassword(account);
//        }
        userService.updatePassword(account);
        return Result.success();
    }

    /**
     * 忘记密码
     */
    @PostMapping("/getQuestion")
    public Result forgetPassword(@RequestBody Account account) {
        User user = new User();
        user.setUsername(account.getUsername());
        List<User> users = userService.selectAll(user);
        if (CollectionUtils.isEmpty(users)) {
            return Result.error(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        User retUser = users.get(0);
        String question = retUser.getQuestion();
        List<QuestionDTO> questionDTOS = JSONArray.parseArray(question, QuestionDTO.class);
        questionDTOS.forEach(questionDTO -> {
            questionDTO.setAnswer(null);
        });
        return Result.success(questionDTOS);
    }

    /**
     * 问题答案更新密码
     */
    @PostMapping("/updatePasswordByQuestion")
    public Result updatePasswordByQuestion(@RequestBody UpdatePwdDTO req) {
        String userName = req.getUserName();
        User user = new User();
        user.setUsername(userName);
        List<User> users = userService.selectAll(user);
        if (CollectionUtils.isEmpty(users)) {
            return Result.error(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        String question = users.get(0).getQuestion();
        List<QuestionDTO> questionDTOS = JSONArray.parseArray(question, QuestionDTO.class);

        Map<String, String> collectMap = questionDTOS.stream().collect(Collectors.toMap(QuestionDTO::getQuestion, QuestionDTO::getAnswer));

        for (QuestionDTO questionDTO : req.getQuestion()) {
            String answer = collectMap.get(questionDTO.getQuestion());
            if (answer.equals(questionDTO.getAnswer())) {
                continue;
            }else {
                return Result.error(ResultCodeEnum.question);
            }
        }
        String password = req.getPassword();
        String newPassword = BCryptUtils.hashPassword(password);
        User user2 = users.get(0);
        user2.setPassword(newPassword);
        userService.updateById(user2);
        return Result.success("更新成功");
    }

}
