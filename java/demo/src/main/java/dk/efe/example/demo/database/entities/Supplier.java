package dk.efe.example.demo.database.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

import java.util.List;

@Entity(name = "stlunch_suppliers")
public class Supplier {
    @Id
    @Column(name="supplier_id")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    @Column(name = "supplier_email", length = 40, nullable = false)
    private String email;
    @Column(name = "supplier_name", length = 40, nullable = false)
    private String name;
    @Column(name = "supplier_phone", length = 40, nullable = true)
    private String phone;
    @Column(name = "order_memo", length = 255, nullable = true)
    private String orderMemo;
    @OneToMany(mappedBy = "supplier")
    private List<SupplierMenu> menus;

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getOrderMemo() {
        return orderMemo;
    }

    public void setOrderMemo(String orderMemo) {
        this.orderMemo = orderMemo;
    }

    public List<SupplierMenu> getMenus() {
        return menus;
    }

    public void setMenus(List<SupplierMenu> menus) {
        this.menus = menus;
    }

}