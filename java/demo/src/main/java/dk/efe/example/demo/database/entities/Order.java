package dk.efe.example.demo.database.entities;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

@Entity(name = "stlunch_orders")
public class Order {
    @Id
    @Column(name="order_id")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    @Column(name = "order_date", nullable = false)
    private LocalDate orderDate;
    @Column(name = "supplier_email", length = 40, nullable = false)
    private String supplierEmail;
    @Column(name = "supplier_name", length = 40, nullable = false)
    private String supplierName;
    @Column(name = "menu_category", length = 40, nullable = false)
    private String menuCategory;
    @Column(name = "menu_name", length = 40, nullable = false)
    private String menuName;
    @Column(name = "items_ordered", nullable = false)
    private long itemsOrdered;
    @Column(name = "price", precision = 6, scale = 2, nullable = false)
    private BigDecimal price;
    @Column(name = "user_comment", length = 255, nullable = true)
    private String userComment;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    @OneToMany(mappedBy = "order", fetch = FetchType.LAZY)
    private List<OrderOption> options;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public LocalDate getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDate orderDate) {
        this.orderDate = orderDate;
    }

    public String getSupplierEmail() {
        return supplierEmail;
    }

    public void setSupplierEmail(String supplierEmail) {
        this.supplierEmail = supplierEmail;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getMenuCategory() {
        return menuCategory;
    }

    public void setMenuCategory(String menuCategory) {
        this.menuCategory = menuCategory;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public long getItemsOrdered() {
        return itemsOrdered;
    }

    public void setItemsOrdered(long itemsOrdered) {
        this.itemsOrdered = itemsOrdered;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getUserComment() {
        return userComment;
    }

    public void setUserComment(String userComment) {
        this.userComment = userComment;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<OrderOption> getOptions() {
        return options;
    }

    public void setOptions(List<OrderOption> options) {
        this.options = options;
    }
}