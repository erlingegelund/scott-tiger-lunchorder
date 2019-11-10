package dk.efe.example.demo.database.entities;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

@Entity(name="stlunch_categories")
public class Category {
    @Id
    @Column(name = "category_id", precision = 10)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @Column(name = "category_name", length = 40, nullable = false)
    private String name;
    @OneToMany(mappedBy = "category", fetch = FetchType.LAZY)
    private List<SupplierMenu> menus;
    
    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public List<SupplierMenu> getMenus() {
        return menus;
    }

    public void setMenus(List<SupplierMenu> menus) {
        this.menus = menus;
    }
}