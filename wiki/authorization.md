## Authorization

```model
user
  has_and_belongs_to_many :roles
role
  has_and_belongs_to_many :users
  has_and_belongs_to_many :permission
permission
  t.string :name, comment: "名称"
  t.string :subject, comment: "模块"
  t.string :uid, comment: "UID"

rails g migration CreateJoinTableRoleUser role:index user:index
rails g migration CreateJoinTablePermissionRoleUser permission:index role:index
```

### 关于用户 role_type

- manager: 0 超级管理员
- normal: 2 普通后台用户
- open_manager: 1 开放平台管理员

超级管理员强行拥有 全部数据 + 全部 permission 的集合

否则安装 role_type 的不一样我们会大致对用户能够获取数据的接口做出一定的限制

- normal 不允许访问 `api/open/` 下面的接口
- open_manager 不允许访问 `api/web/` 下面的接口

### 关于 permission

用户具体的一些操作权限来自于角色下面所属的权限集合