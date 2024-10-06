import { Component, EventEmitter, Input, Output } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {
  @Input() searchTerm: string = ''; 
  @Output() searchTermChange: EventEmitter<string> = new EventEmitter<string>();
  constructor(private router: Router) {}

  onSearchTermChange(): void {
    this.searchTermChange.emit(this.searchTerm);
  }
}
