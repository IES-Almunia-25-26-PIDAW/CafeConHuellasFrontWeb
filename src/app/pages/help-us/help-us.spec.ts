import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HelpUs } from './help-us';

describe('HelpUs', () => {
  let component: HelpUs;
  let fixture: ComponentFixture<HelpUs>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [HelpUs]
    })
    .compileComponents();

    fixture = TestBed.createComponent(HelpUs);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
