package dk.efe.example.demo.database.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import dk.efe.example.demo.database.entities.Supplier;

public interface SupplierRepository extends JpaRepository<Supplier, Long> {}