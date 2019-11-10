package dk.efe.example.demo.database.entities;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

@Entity(name = "stlunch_users")
public class User {
    @Id
    @Column(name="user_id", precision = 10)
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @Column(name = "user_email", length = 40, nullable = false)
    private String email;
    @Column(name = "user_name", length = 40, nullable = false)
    private String name;
    @Column(name = "administrator_yn", length = 1, nullable = false)
    private Boolean administrator;
    @Column(name = "inactive_yn", length = 1, nullable = true)
    private Boolean inactive;
    @Column(name = "passwd_salt", length = 10 )
    private String passwdSalt;
    @Column(name = "passwd_enc", length = 255) 
    private String passwdEnc;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<Order> orders;

    public Long getId() {
        return id;
    }

    public Boolean getInactive() {
        return inactive;
    }

    public void setInactive(Boolean inactive) {
        this.inactive = inactive;
    }

    public Boolean getAdministrator() {
        return administrator;
    }

    public void setAdministrator(Boolean administrator) {
        this.administrator = administrator;
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

    public void setId(Long id) {
        this.id = id;
    }

    public List<Order> getOrders() {
        return orders;
    }

    public void setOrders(List<Order> orders) {
        this.orders = orders;
    }

    public String getPasswdSalt() {
        return passwdSalt;
    }

    public void setPasswdSalt(String passwdSalt) {
        this.passwdSalt = passwdSalt;
    }

    public String getPasswdEnc() {
        return passwdEnc;
    }

    public void setPasswdEnc(String passwdEnc) {
        this.passwdEnc = passwdEnc;
    }

}