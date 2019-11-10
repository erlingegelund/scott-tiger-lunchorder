package dk.efe.example.demo.database.entities;

import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Entity(name = "stlunch_menu_options")
public class MenuOption {
    @Id
    @Column(name="menu_option_id")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    @Column(name = "description", length = 40, nullable = false)
    private String description;
    @Column(name = "mandatory_yn", length = 1, nullable = false)
    private Boolean mandatory;
    @Column(name = "multiple_yn", length = 1, nullable = false)
    private Boolean multiple;
    @Column(name = "additional_price", precision = 6, scale = 2, nullable = true)
    private BigDecimal additionalPrice;
    @Column(name = "selectables", length = 4000, nullable = true)
    private String selectables;
    @Column(name = "sort_order", nullable = true)
    private Long sortOrder;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "supplier_menu_id", nullable = false)
    private SupplierMenu menu;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getMandatory() {
        return mandatory;
    }

    public void setMandatory(Boolean mandatory) {
        this.mandatory = mandatory;
    }

    public Boolean getMultiple() {
        return multiple;
    }

    public void setMultiple(Boolean multiple) {
        this.multiple = multiple;
    }

    public BigDecimal getAdditionalPrice() {
        return additionalPrice;
    }

    public void setAdditionalPrice(BigDecimal additionalPrice) {
        this.additionalPrice = additionalPrice;
    }

    public String getSelectables() {
        return selectables;
    }

    public void setSelectables(String selectables) {
        this.selectables = selectables;
    }

    public Long getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Long sortOrder) {
        this.sortOrder = sortOrder;
    }

    public SupplierMenu getMenu() {
        return menu;
    }

    public void setMenu(SupplierMenu menu) {
        this.menu = menu;
    }


}