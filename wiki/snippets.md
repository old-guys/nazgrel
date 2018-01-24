```shell
rails generate model contact name:string user:references remark:string lead_name:string custom_name:string department:string job:string

rails g controller customers index new edit

rails generate migration add_owner_id_to_customer owner_id:integer

rails g scaffold_controller api/web/permission --api
```