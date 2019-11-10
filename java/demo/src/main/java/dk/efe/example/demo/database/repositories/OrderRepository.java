package dk.efe.example.demo.database.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import dk.efe.example.demo.database.entities.Order;

public interface OrderRepository extends JpaRepository<Order, Long> {}